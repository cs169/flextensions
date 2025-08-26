require 'rails_helper'

RSpec.describe SyncAllCourseAssignmentsJob, type: :job do
  let(:course) { create(:course, :with_staff, :with_students) }
  let(:course_to_lms) { course.course_to_lms(1) }
  # We need to use *a* staff user for the sync, this just returns the first.
  let(:sync_user) { course.staff_users.first }

  # TODO: Spec out the return values of the job
  # TODO: Spec out that it updates course_to_lms.recent_assignment_sync
  # TODO: Spec out behavior for add/update/delete assignments
  describe '#perform' do
    let(:canvas_assignments) do
      [
        {
          'id' => '123',
          'name' => 'Assignment 1',
          'due_at' => '2025-01-15T23:59:00Z',
          'lock_at' => '2025-01-20T23:59:00Z'
        },
        {
          'id' => '456',
          'name' => 'Assignment 2',
          'due_at' => '2025-02-15T23:59:00Z',
          'lock_at' => nil
        }
      ]
    end

    before do
      course.assignments.destroy_all

      allow_any_instance_of(CourseToLms).to receive(:get_all_canvas_assignments)
        .with(sync_user)
        .and_return(canvas_assignments)
    end

    it 'creates new assignments from Canvas data' do
      expect {
        described_class.perform_now(course_to_lms.id, sync_user.id)
      }.to change(Assignment, :count).by(2)

      assignment1 = Assignment.find_by(external_assignment_id: '123')
      expect(assignment1.name).to eq('Assignment 1')
      expect(assignment1.due_date).to eq(DateTime.parse('2025-01-15T23:59:00Z'))
      expect(assignment1.late_due_date).to eq(DateTime.parse('2025-01-20T23:59:00Z'))

      assignment2 = Assignment.find_by(external_assignment_id: '456')
      expect(assignment2.name).to eq('Assignment 2')
      expect(assignment2.due_date).to eq(DateTime.parse('2025-02-15T23:59:00Z'))
      expect(assignment2.late_due_date).to be_nil
    end

    it 'updates existing assignments' do
      existing_assignment = create(:assignment,
        course_to_lms: course_to_lms,
        external_assignment_id: '123',
        name: 'Old Name'
      )

      described_class.perform_now(course_to_lms.id, sync_user.id)

      existing_assignment.reload
      expect(existing_assignment.name).to eq('Assignment 1')
    end

    it 'deletes assignments that no longer exist in Canvas' do
      orphaned_assignment = create(:assignment,
        course_to_lms: course_to_lms,
        external_assignment_id: '999',
        name: 'Orphaned Assignment'
      )

      expect {
        described_class.perform_now(course_to_lms.id, sync_user.id)
      }.to change(Assignment, :count).by(1) # 2 new, 1 deleted = +1

      expect(Assignment.find_by(id: orphaned_assignment.id)).to be_nil
    end

    it 'returns sync results' do
      result = described_class.perform_now(course_to_lms.id, sync_user.id)

      expect(result).to include(
        added_assignments: 2,
        updated_assignments: 0,
        unchanged_assignments: 0,
        deleted_assignments: 0,
        synced_at: be_within(1.second).of(Time.current)
      )
    end

    context 'when assignment has base_date field' do
      let(:canvas_assignments) do
        [
          {
            'id' => '123',
            'name' => 'Assignment with base_date',
            'due_at' => nil,
            'lock_at' => nil,
            'base_date' => {
              'due_at' => '2025-03-15T23:59:00Z',
              'lock_at' => '2025-03-20T23:59:00Z'
            }
          }
        ]
      end

      it 'uses base_date when present' do
        described_class.perform_now(course_to_lms.id, sync_user.id)

        assignment = Assignment.find_by(external_assignment_id: '123')
        expect(assignment.due_date).to eq(DateTime.parse('2025-03-15T23:59:00Z'))
        expect(assignment.late_due_date).to eq(DateTime.parse('2025-03-20T23:59:00Z'))
      end
    end

    context 'when sync_user is not staff' do
      let(:student_user) { course.students.first }

      before do
        allow_any_instance_of(CourseToLms).to receive(:get_all_canvas_assignments)
          .with(any_args) # Accept any arguments
          .and_return(canvas_assignments)
      end

      it 'can still perform the job' do
        expect {
          described_class.perform_now(course_to_lms.id, student_user.id)
        }.not_to raise_error
      end
    end
  end


  # THIS MUST BE REWRITTEN
  # This was moved from Course.sync_assignment
  # It is now a helper method within the job.
  describe '.sync_assignment' do
    it 'creates or updates an assignment' do
      pending 'moved from course_spec and should be rewritten'
      assignment_data = { 'id' => 'a123', 'name' => 'HW1', 'due_at' => 1.day.from_now.to_s }
      expect do
        described_class.sync_assignment(course_to_lms, assignment_data)
      end.to change(Assignment, :count).by(1)

      assignment = Assignment.last
      expect(assignment.name).to eq('HW1')
    end
  end

  # This was also migrated from the course spec.
  # describe '.sync_assignments' do
  #   it 'calls sync_assignment for each assignment and deletes missing ones' do
  #     Assignment.create!(name: 'Old', course_to_lms_id: course_to_lms.id, external_assignment_id: 'old')

  #     allow(course_to_lms).to receive(:get_all_canvas_assignments).and_return([
  #       { 'id' => 'new1', 'name' => 'New Assignment', 'due_at' => nil }
  #     ])

  #     # one created, one deleted
  #     expect do
  #       described_class.sync_assignments(course_to_lms, 'fake_token')
  #     end.not_to(change(Assignment, :count))
  #     expect(Assignment.find_by(external_assignment_id: 'old')).to be_nil
  #     expect(Assignment.find_by(external_assignment_id: 'new1')).not_to be_nil
  #   end
  # end
end
