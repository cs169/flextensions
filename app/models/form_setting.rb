class FormSetting < ApplicationRecord
  belongs_to :course

  # model-level validations for display enums
  validates :documentation_disp, :custom_q1_disp, :custom_q2_disp, inclusion: { in: %w[required optional hidden] }
end
