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

  # Class methods
  def self.merge_date_and_time!(request_params)
    return unless request_params[:requested_due_date].present? && request_params[:due_time].present?

    combined = Time.zone.parse("#{request_params[:requested_due_date]} #{request_params[:due_time]}")
    request_params[:requested_due_date] = combined
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
    return false unless course&.course_settings.present?

    course.course_settings.enable_extensions &&
      course.course_settings.auto_approve_days.positive?
  end

  def eligible_for_auto_approval?
    return false unless course&.course_settings.present?
    return false unless course.course_settings.enable_extensions?
    return false if course.course_settings.auto_approve_days.zero?

    days_difference = calculate_days_difference
    return false if days_difference <= 0 || days_difference > course.course_settings.auto_approve_days

    # Check if this would be within the maximum auto-approvals for this student
    max_approvals = course.course_settings.max_auto_approve
    return true if max_approvals.zero? # If max is 0, there's no limit

    # Count how many requests have already been auto-approved for this student in this course
    approved_count = Request.approved_for_user_in_course(user, course).count
    approved_count < max_approvals
  end

  def auto_approve(canvas_facade)
    return false unless eligible_for_auto_approval?

    # Get the auto-approval system user
    system_user = SystemUserService.auto_approval_user

    # If the system user doesn't exist yet, create it
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
  end

  def reject(processed_user_id)
    update(status: 'denied', last_processed_by_user_id: processed_user_id.id)
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
      course.canvas_id,
      assignment.external_assignment_id,
      [user.canvas_uid],
      "Extension for #{user.name}",
      requested_due_date.iso8601,
      nil, # Unlock date (optional)
      nil  # Lock date (optional)
    )
  end
end
