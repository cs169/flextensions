require 'rails_helper'

RSpec.describe SyncAllCourseAssignmentsJob, type: :job do
  let(:course) { create(:course) }
  let(:course_to_lms) { create(:course_to_lms, course: course) }
  let(:token) { 'test_token' }

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
      allow_any_instance_of(CourseToLms).to receive(:get_all_canvas_assignments)
        .with(token)
        .and_return(canvas_assignments)
    end

    it 'creates new assignments from Canvas data' do
      expect {
        SyncAllCourseAssignmentsJob.perform_now(course_to_lms.id, token)
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

      SyncAllCourseAssignmentsJob.perform_now(course_to_lms.id, token)

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
        SyncAllCourseAssignmentsJob.perform_now(course_to_lms.id, token)
      }.to change(Assignment, :count).by(1) # 2 new, 1 deleted = +1

      expect(Assignment.find_by(id: orphaned_assignment.id)).to be_nil
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
        SyncAllCourseAssignmentsJob.perform_now(course_to_lms.id, token)

        assignment = Assignment.find_by(external_assignment_id: '123')
        expect(assignment.due_date).to eq(DateTime.parse('2025-03-15T23:59:00Z'))
        expect(assignment.late_due_date).to eq(DateTime.parse('2025-03-20T23:59:00Z'))
      end
    end
  end
end
