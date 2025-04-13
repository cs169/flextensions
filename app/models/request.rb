class Request < ApplicationRecord
  belongs_to :course
  belongs_to :assignment
  belongs_to :user
  belongs_to :last_processed_by_id, class_name: 'User', optional: true

  delegate :form_setting, to: :course, allow_nil: true

  validates :requested_due_date, :reason, presence: true
end
