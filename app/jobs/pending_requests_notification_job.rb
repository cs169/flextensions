class PendingRequestsNotificationJob < ApplicationJob
  queue_as :default

  def perform(frequency)
    CourseSettings.with_pending_notifications(frequency).includes(:course).find_each do |cs|
      course = cs.course
      pending_count = Request.where(course_id: course.id, status: 'pending').count
      next if pending_count.zero?

      requests_url = "#{ENV.fetch('APP_HOST', nil)}/courses/#{course.id}/requests"

      EmailService.send_email(
        to: cs.pending_notification_email,
        from: ENV.fetch('DEFAULT_FROM_EMAIL'),
        reply_to: cs.reply_email.presence || ENV.fetch('DEFAULT_FROM_EMAIL'),
        subject_template: '{{pending_count}} Pending Extension Request{{plural}} - {{course_code}}',
        body_template: "Hello,\n\nYou have {{pending_count}} pending extension request{{plural}} " \
                       "in {{course_name}} ({{course_code}}).\n\n" \
                       "Please review them at: {{requests_url}}\n\n" \
                       "Thank you,\nFlextensions",
        mapping: {
          'pending_count' => pending_count.to_s,
          'plural' => pending_count == 1 ? '' : 's',
          'course_name' => course.course_name,
          'course_code' => course.course_code,
          'requests_url' => requests_url
        },
        deliver_later: false
      )
    end
  end
end
