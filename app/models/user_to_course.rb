# == Schema Information
#
# Table name: user_to_courses
#
#  id         :bigint           not null, primary key
#  role       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  course_id  :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_user_to_courses_on_course_id  (course_id)
#  index_user_to_courses_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#  fk_rails_...  (user_id => users.id)
#
class UserToCourse < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :course

  # Validations
  validates :role, presence: true
end
