class Assignment < ApplicationRecord
    #Relationship with Lms
    belongs_to :lms

    #Relationship with Extension
    has_many :extensions
end