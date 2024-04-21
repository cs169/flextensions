# app/models/assignment.rb
class Assignment < ApplicationRecord
    belongs_to :course_to_lms
  
    validates :name, presence: true
    validates :external_assignment_id, presence: true
  end