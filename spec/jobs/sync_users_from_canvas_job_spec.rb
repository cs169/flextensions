require 'rails_helper'

RSpec.describe SyncUsersFromCanvasJob, type: :job do
  let(:course) { create(:course, :with_staff) }
  let(:sync_user) { course.staff_users.first }
  let(:canvas_facade_double) { instance_double(CanvasFacade) }

  before do
    allow(sync_user).to receive(:ensure_fresh_canvas_token!).and_return('fake_token')
    allow(CanvasFacade).to receive(:new).with('fake_token').and_return(canvas_facade_double)
  end

  describe '#perform' do
    context 'user upsert' do
      let(:canvas_user) { create(:user) }
      let(:canvas_data) do
        [ { 'id' => canvas_user.canvas_uid, 'name' => canvas_user.name,
           'email' => canvas_user.email, 'sis_user_id' => canvas_user.student_id } ]
      end

      before do
        allow(canvas_facade_double).to receive(:get_all_course_users).and_return(canvas_data)
      end

      it 'creates new users from Canvas data when they do not exist locally' do
        new_uid = 'brand-new-canvas-uid'
        allow(canvas_facade_double).to receive(:get_all_course_users)
          .and_return([ { 'id' => new_uid, 'name' => 'New Person', 'email' => 'new@example.com', 'sis_user_id' => 'S99' } ])

        expect {
          described_class.perform_now(course.id, sync_user.id, 'student')
        }.to change(User, :count).by(1)

        expect(User.find_by(canvas_uid: new_uid)).to have_attributes(name: 'New Person', email: 'new@example.com')
      end

      it 'updates an existing user without creating a duplicate' do
        canvas_user.update!(name: 'Old Name')
        updated_data = [ { 'id' => canvas_user.canvas_uid, 'name' => 'New Name',
                          'email' => canvas_user.email, 'sis_user_id' => canvas_user.student_id } ]
        allow(canvas_facade_double).to receive(:get_all_course_users).and_return(updated_data)

        expect {
          described_class.perform_now(course.id, sync_user.id, 'student')
        }.not_to change(User, :count)

        expect(canvas_user.reload.name).to eq('New Name')
      end

      it 'skips users with a blank email' do
        allow(canvas_facade_double).to receive(:get_all_course_users)
          .and_return([ { 'id' => 'no-email', 'name' => 'No Email', 'email' => '', 'sis_user_id' => nil } ])

        expect {
          described_class.perform_now(course.id, sync_user.id, 'student')
        }.not_to change(User, :count)
      end
    end

    context 'enrollment creation' do
      let(:first_student) { create(:user) }
      let(:second_student) { create(:user) }
      let(:canvas_data) do
        [ first_student, second_student ].map do |u|
          { 'id' => u.canvas_uid, 'name' => u.name, 'email' => u.email, 'sis_user_id' => u.student_id }
        end
      end

      before do
        allow(canvas_facade_double).to receive(:get_all_course_users).and_return(canvas_data)
      end

      it 'creates UserToCourse enrollments for synced users' do
        expect {
          described_class.perform_now(course.id, sync_user.id, 'student')
        }.to change(UserToCourse, :count).by(2)

        expect(UserToCourse.exists?(user: first_student, course: course, role: 'student')).to be true
        expect(UserToCourse.exists?(user: second_student, course: course, role: 'student')).to be true
      end

      it 'assigns the correct role to enrollments' do
        described_class.perform_now(course.id, sync_user.id, 'ta')

        expect(UserToCourse.find_by(user: first_student, course: course).role).to eq('ta')
      end

      it 'does not duplicate enrollments on re-run' do
        described_class.perform_now(course.id, sync_user.id, 'student')

        expect {
          described_class.perform_now(course.id, sync_user.id, 'student')
        }.not_to change(UserToCourse, :count)
      end
    end

    context 'role-based removal' do
      let(:remaining) { create(:user) }
      let(:removed)   { create(:user) }

      before do
        create(:user_to_course, user: removed, course: course, role: 'student')
        allow(canvas_facade_double).to receive(:get_all_course_users)
          .and_return([ { 'id' => remaining.canvas_uid, 'name' => remaining.name,
                         'email' => remaining.email, 'sis_user_id' => remaining.student_id } ])
      end

      it 'removes enrollments for users no longer returned by Canvas' do
        # Also pre-enroll `remaining` so the job's insert doesn't offset the removal
        create(:user_to_course, user: remaining, course: course, role: 'student')

        expect {
          described_class.perform_now(course.id, sync_user.id, 'student')
        }.to change(UserToCourse, :count).by(-1)

        expect(UserToCourse.exists?(user: removed, course: course)).to be false
      end

      it 'does not remove enrollments for other roles' do
        teacher = create(:user)
        create(:user_to_course, user: teacher, course: course, role: 'teacher')

        described_class.perform_now(course.id, sync_user.id, 'student')

        expect(UserToCourse.exists?(user: teacher, course: course, role: 'teacher')).to be true
      end
    end

    context 'multiple roles' do
      let(:student) { create(:user) }
      let(:ta)      { create(:user) }

      before do
        allow(canvas_facade_double).to receive(:get_all_course_users).with(anything, 'student')
          .and_return([ { 'id' => student.canvas_uid, 'name' => student.name, 'email' => student.email, 'sis_user_id' => student.student_id } ])
        allow(canvas_facade_double).to receive(:get_all_course_users).with(anything, 'ta')
          .and_return([ { 'id' => ta.canvas_uid, 'name' => ta.name, 'email' => ta.email, 'sis_user_id' => ta.student_id } ])
      end

      it 'syncs each role independently' do
        described_class.perform_now(course.id, sync_user.id, %w[student ta])

        expect(UserToCourse.exists?(user: student, course: course, role: 'student')).to be true
        expect(UserToCourse.exists?(user: ta,      course: course, role: 'ta')).to be true
      end
    end

    context 'return value and persistence' do
      # Use a canvas_uid not in the DB so the job counts this as an add, not an update
      let(:canvas_data) do
        [ { 'id' => 'brand-new-uid-999', 'name' => 'New Student', 'email' => 'newstudent@example.com', 'sis_user_id' => 'S999' } ]
      end

      before do
        allow(canvas_facade_double).to receive(:get_all_course_users).and_return(canvas_data)
      end

      it 'returns results keyed by role with added/removed/updated counts' do
        result = described_class.perform_now(course.id, sync_user.id, 'student')

        # The job keys results with string role names
        expect(result['student']).to include(added: 1, removed: 0, updated: 0)
      end

      it 'includes a synced_at timestamp' do
        result = described_class.perform_now(course.id, sync_user.id, 'student')

        expect(result[:synced_at]).to be_within(1.second).of(Time.current)
      end

      it 'persists results to course_to_lms.recent_roster_sync' do
        described_class.perform_now(course.id, sync_user.id, 'student')

        expect(course.course_to_lms(1).reload.recent_roster_sync).to include('student' => include('added' => 1))
      end
    end

    context 'when Canvas returns a non-array response' do
      before do
        allow(canvas_facade_double).to receive(:get_all_course_users).and_return({ 'error' => 'unauthorized' })
      end

      it 'returns zeroed counts without raising' do
        result = nil
        expect {
          result = described_class.perform_now(course.id, sync_user.id, 'student')
        }.not_to raise_error

        # The job keys results with string role names
        expect(result['student']).to eq(added: 0, removed: 0, updated: 0)
      end
    end
  end
end
