class CourseToLms < ApplicationRecord
    belongs_to :lms
    belongs_to :course
end