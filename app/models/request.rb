class Request < ApplicationRecord
  belongs_to :course
  belongs_to :assignment
  belongs_to :user
  belongs_to :last_processed_by_user, class_name: "User", foreign_key: "last_processed_by_user_id", optional: true

  delegate :form_setting, to: :course, allow_nil: true

  validates :requested_due_date, :reason, presence: true

  scope :for_user, ->(user) { where(user: user).includes(:assignment) }

  def calculate_days_difference
    (requested_due_date.to_date - assignment.due_date.to_date).to_i
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
