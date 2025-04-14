# app/models/assignment.rb
class Assignment < ApplicationRecord
  belongs_to :course_to_lms
  has_many :requests, dependent: :destroy

  validates :name, presence: true
  validates :external_assignment_id, presence: true
  has_many :extensions
end
