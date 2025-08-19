# == Schema Information
#
# Table name: requests
#
#  id                        :bigint           not null, primary key
#  auto_approved             :boolean          default(FALSE), not null
#  custom_q1                 :text
#  custom_q2                 :text
#  documentation             :text
#  reason                    :text
#  requested_due_date        :datetime
#  status                    :enum             default("pending"), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  assignment_id             :bigint           not null
#  course_id                 :bigint           not null
#  external_extension_id     :string
#  last_processed_by_user_id :bigint
#  user_id                   :bigint           not null
#
# Indexes
#
#  index_requests_on_assignment_id              (assignment_id)
#  index_requests_on_auto_approved              (auto_approved)
#  index_requests_on_course_id                  (course_id)
#  index_requests_on_last_processed_by_user_id  (last_processed_by_user_id)
#  index_requests_on_user_id                    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (assignment_id => assignments.id)
#  fk_rails_...  (course_id => courses.id)
#  fk_rails_...  (last_processed_by_user_id => users.id)
#  fk_rails_...  (user_id => users.id)
#
class Request < ApplicationRecord
  belongs_to :course
  belongs_to :assignment
  belongs_to :user
  belongs_to :last_processed_by_user, class_name: 'User', optional: true

  delegate :form_setting, to: :course, allow_nil: true
  validates :requested_due_date, :reason, presence: true

  scope :for_user, ->(user) { where(user: user).includes(:assignment) }
  scope :approved_for_user_in_course, lambda { |user, course|
    where(user: user, course: course, status: 'approved')
  }
  scope :auto_approved_for_user_in_course, lambda { |user, course|
    where(user: user, course: course, status: 'approved', auto_approved: true)
  }

  # Class methods
  def self.merge_date_and_time!(request_params)
    return unless request_params[:requested_due_date].present? && request_params[:due_time].present?

    combined = Time.zone.parse("#{request_params[:requested_due_date]} #{request_params[:due_time]}")
    request_params[:requested_due_date] = combined
  end

  # Process a newly created request, including auto-approval check
  # TODO: This should be APP_HOST or something like:
  # Rails.application.routes.default_url_options[:host]
  def process_created_request(current_user)
    link = "#{ENV.fetch('CANVAS_REDIRECT_URI', nil)}/courses/#{course.id}/requests/#{id}"

    if try_auto_approval(current_user)
      slack_message, result = build_created_slack_and_result(:auto_approved, link)
    else
      slack_message, result = build_created_slack_and_result(:pending, link)
    end

    notify_slack(slack_message)

    result
  end

  # Handle request update and check for auto-approval
  def process_update(current_user)
    link = "#{ENV.fetch('CANVAS_REDIRECT_URI', nil)}/courses/#{course.id}/requests/#{id}"
    notify_slack = true

    if status == 'pending' && try_auto_approval(current_user)
      slack_message = build_slack_message(:auto_approved, link)
      result = build_result_hash('Your request was updated and has been approved.')
    else
      slack_message = build_slack_message(:updated, link)
      result = build_result_hash('Request was successfully updated.')
    end

    success = SlackNotifier.notify(slack_message, course.course_settings.slack_webhook_url) if notify_slack && course&.course_settings&.slack_webhook_url.present?
    Rails.logger.error "Failed to send Slack notification for request #{id} in course #{course.id}. Please check your webhook URL." unless success
    result
  end

  def calculate_days_difference
    (requested_due_date.to_date - assignment.due_date.to_date).to_i
  end

  def try_auto_approval(current_user)
    return false unless auto_approval_eligible_for_course?

    token = current_user.lms_credentials.first&.token
    return false unless token.present? && eligible_for_auto_approval?

    canvas_facade = CanvasFacade.new(token)
    auto_approve(canvas_facade)
  end

  def auto_approval_eligible_for_course?
    return false if course&.course_settings.blank?

    course.course_settings.enable_extensions &&
      course.course_settings.auto_approve_days.positive?
  end

  def eligible_for_auto_approval?
    return false if course&.course_settings.blank?
    return false unless course.course_settings.enable_extensions?
    return false if course.course_settings.auto_approve_days.zero?

    days_difference = calculate_days_difference
    return false if days_difference <= 0 || days_difference > course.course_settings.auto_approve_days

    max_approvals = course.course_settings.max_auto_approve
    return true if max_approvals.zero? # If max is 0, there's no limit

    auto_approved_count = Request.auto_approved_for_user_in_course(user, course).count
    auto_approved_count < max_approvals
  end

  def auto_approve(canvas_facade)
    return false unless eligible_for_auto_approval?

    system_user = SystemUserService.auto_approval_user
    system_user ||= SystemUserService.ensure_auto_approval_user_exists

    return false unless system_user

    # Reuse the regular approve method but mark as auto-approved afterward
    result = approve(canvas_facade, system_user)
    update(auto_approved: true) if result
    result
  end

  def approve(canvas_facade, processed_user_id)
    existing_override = existing_override(canvas_facade)

    delete_override(canvas_facade, existing_override['id']) if existing_override

    response = create_override(canvas_facade)
    return false unless response.success?

    assignment_override = JSON.parse(response.body)
    update(status: 'approved', last_processed_by_user_id: processed_user_id.id, external_extension_id: assignment_override['id'])
    send_email_response if course.course_settings&.enable_emails
    true
  end

  def reject(processed_user_id)
    update(status: 'denied', last_processed_by_user_id: processed_user_id.id)
    # Only send email if the person processing is the same as the request's user
    send_email_response if course.course_settings&.enable_emails && processed_user_id.id != user_id
    true
  end

  # app/models/request.rb
  def send_email_response
    return unless course.course_settings&.enable_emails

    cs = course.course_settings
    to = user.email
    reply_to = cs.reply_email.presence || ENV.fetch('DEFAULT_FROM_EMAIL')

    # build the mapping without braces:
    mapping = {
      'student_name' => user.name,
      'assignment_name' => assignment.name,
      'course_name' => course.course_name,
      'course_code' => course.course_code,
      'status' => status.capitalize,
      'original_due_date' => assignment.due_date.strftime('%a, %b %-d, %Y %-I:%M %p'),
      'new_due_date' => requested_due_date.strftime('%a, %b %-d, %Y %-I:%M %p'),
      'extension_days' => calculate_days_difference.to_s
    }

    EmailService.send_email(
      to: to,
      from: ENV.fetch('DEFAULT_FROM_EMAIL'),
      reply_to: reply_to,
      subject_template: cs.email_subject,
      body_template: cs.email_template,
      mapping: mapping,
      deliver_later: false # or true if you prefer .deliver_later
    )
  end

  def self.to_csv(requests)
    headers = ['Assignment', 'Student Name', 'Student ID', 'Requested At', 'Original Due Date', 'Requested Due Date', 'Status']
    CSV.generate(headers: true) do |csv|
      csv << headers
      requests.find_each do |request|
        csv << [
          request.assignment&.name,
          request.user&.name,
          request.user&.student_id,
          request.created_at,
          request.assignment&.due_date,
          request.requested_due_date,
          request.status
        ]
      end
    end
  end

  private

  def existing_override(canvas_facade)
    overrides_response = canvas_facade.get_assignment_overrides(course.canvas_id, assignment.external_assignment_id)
    return nil unless overrides_response.success?

    overrides = JSON.parse(overrides_response.body)
    overrides.find { |override| override['student_ids'].map(&:to_i).include?(user.canvas_uid.to_i) }
  end

  def delete_override(canvas_facade, override_id)
    canvas_facade.delete_assignment_override(course.canvas_id, assignment.external_assignment_id, override_id)
  end

  def create_override(canvas_facade)
    canvas_facade.create_assignment_override(
      course.canvas_id, assignment.external_assignment_id, [user.canvas_uid], "Extension for #{user.name}",
      requested_due_date.iso8601, nil, nil
    )
  end

  def build_slack_message(type, link)
    case type
    when :auto_approved
      "A pending request was *updated and auto-approved* for '#{assignment&.name}' (#{user&.name}) in course '#{course&.course_name}'.\nView: #{link}"
    when :updated
      "A pending request was *updated* for '#{assignment&.name}' (#{user&.name}) in course '#{course&.course_name}'.\nView: #{link}"
    end
  end

  def build_result_hash(notice)
    {
      redirect_to: Rails.application.routes.url_helpers.course_request_path(course, id),
      notice: notice
    }
  end

  def build_created_slack_and_result(type, link)
    case type
    when :auto_approved
      [
        "A request was *auto-approved* for '#{assignment&.name}' (#{user&.name}) in course '#{course&.course_name}'.\nView: #{link}",
        {
          redirect_to: Rails.application.routes.url_helpers.course_request_path(course, id),
          notice: 'Your extension request has been approved.'
        }
      ]
    when :pending
      [
        "A new extension request is *pending* for review: '#{assignment&.name}' (#{user&.name}) in course '#{course&.course_name}'.\nView: #{link}",
        {
          redirect_to: Rails.application.routes.url_helpers.course_request_path(course, id),
          notice: 'Your extension request has been submitted.'
        }
      ]
    end
  end

  def notify_slack(slack_message)
    return if course&.course_settings&.slack_webhook_url.blank?

    success = SlackNotifier.notify(slack_message, course.course_settings.slack_webhook_url)
    Rails.logger.error "Failed to send Slack notification for request #{id} in course #{course.id}. Please check your webhook URL." unless success
  end
end
