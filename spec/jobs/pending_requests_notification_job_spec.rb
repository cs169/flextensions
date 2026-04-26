require 'rails_helper'

RSpec.describe PendingRequestsNotificationJob, type: :job do
  let(:course) { create(:course, canvas_id: 'notif_123', course_name: 'CS 101', course_code: 'CS101') }
  let(:student) { create(:user, canvas_uid: 'stu_notif_1', email: 'student_notif@example.com', name: 'Student') }
  let(:lms) { Lms.first }
  let(:course_to_lms) { CourseToLms.create!(course: course, lms: lms, external_course_id: 'ext_123') }
  let(:assignment) do
    Assignment.create!(
      name: 'HW1',
      course_to_lms: course_to_lms,
      due_date: 3.days.from_now,
      external_assignment_id: 'asgn_notif_1',
      enabled: true
    )
  end

  before do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.deliveries.clear
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with('DEFAULT_FROM_EMAIL').and_return('flextensions@berkeley.edu')
    allow(ENV).to receive(:fetch).with('APP_HOST', nil).and_return('http://localhost:3000')
  end

  describe '#perform' do
    it 'sends email when course has matching frequency and pending requests' do
      course.course_settings.update!(pending_notification_frequency: 'daily', pending_notification_email: 'prof@example.com')
      Request.create!(course: course, assignment: assignment, user: student, status: 'pending',
                      reason: 'Need more time', requested_due_date: 5.days.from_now)

      expect { described_class.perform_now('daily') }.to change { ActionMailer::Base.deliveries.count }.by(1)

      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to eq([ 'prof@example.com' ])
      expect(mail.subject).to include('1 Pending Extension Request')
      expect(mail.subject).to include('CS101')
      expect(mail.body.encoded).to include("http://localhost:3000/courses/#{course.id}/requests")
    end

    it 'skips courses with zero pending requests' do
      course.course_settings.update!(pending_notification_frequency: 'daily', pending_notification_email: 'prof@example.com')

      expect { described_class.perform_now('daily') }.not_to(change { ActionMailer::Base.deliveries.count })
    end

    it 'only sends to courses matching the given frequency' do
      course.course_settings.update!(pending_notification_frequency: 'weekly', pending_notification_email: 'prof@example.com')
      Request.create!(course: course, assignment: assignment, user: student, status: 'pending',
                      reason: 'Need more time', requested_due_date: 5.days.from_now)

      expect { described_class.perform_now('daily') }.not_to(change { ActionMailer::Base.deliveries.count })
    end

    it 'pluralizes correctly for multiple pending requests' do
      course.course_settings.update!(pending_notification_frequency: 'daily', pending_notification_email: 'prof@example.com')
      2.times do |i|
        Request.create!(course: course, assignment: assignment,
                        user: create(:user, canvas_uid: "stu_multi_#{i}", email: "stu_multi_#{i}@example.com"),
                        status: 'pending', reason: 'Need time', requested_due_date: 5.days.from_now)
      end

      described_class.perform_now('daily')

      mail = ActionMailer::Base.deliveries.last
      expect(mail.subject).to include('2 Pending Extension Requests')
    end

    it 'sends separate emails to multiple courses' do
      course.course_settings.update!(pending_notification_frequency: 'daily', pending_notification_email: 'prof1@example.com')
      Request.create!(course: course, assignment: assignment, user: student, status: 'pending',
                      reason: 'Need time', requested_due_date: 5.days.from_now)

      other_course = create(:course, canvas_id: 'notif_456', course_name: 'CS 201', course_code: 'CS201')
      other_ctlms = CourseToLms.create!(course: other_course, lms: lms, external_course_id: 'ext_456')
      other_assignment = Assignment.create!(name: 'HW2', course_to_lms: other_ctlms, due_date: 3.days.from_now,
                                            external_assignment_id: 'asgn_notif_2', enabled: true)
      other_course.course_settings.update!(pending_notification_frequency: 'daily', pending_notification_email: 'prof2@example.com')
      other_student = create(:user, canvas_uid: 'stu_notif_2', email: 'stu_notif_2@example.com')
      Request.create!(course: other_course, assignment: other_assignment, user: other_student, status: 'pending',
                      reason: 'Need time', requested_due_date: 5.days.from_now)

      expect { described_class.perform_now('daily') }.to change { ActionMailer::Base.deliveries.count }.by(2)
    end
  end
end
