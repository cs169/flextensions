class Course < ApplicationRecord

    #Relationship with User (and UserToCourse)
    has_many :user_to_courses
    has_many :users, :through => :user_to_courses

    #Relationship with Lms (and CourseToLms)
    has_many :course_to_lmss
    has_many :lmss, :through => :course_to_lmss
end