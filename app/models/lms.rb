class Lms < ApplicationRecord
    #Relationship with Course (and CourseToLms)
    has_many :course_to_lmss
    has_many :courses, :through => :course_to_lmss

    #Relationship with Assignment
    has_many :assignments
end