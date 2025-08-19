# == Schema Information
#
# Table name: lmss
#
#  id             :bigint           not null, primary key
#  lms_name       :string
#  use_auth_token :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Lms < ApplicationRecord
  # Relationship with Course (and CourseToLms)
  has_many :course_to_lmss
  has_many :courses, through: :course_to_lmss

  # Relationship with Assignment
  has_many :assignments
end
