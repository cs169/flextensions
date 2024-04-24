class Extension < ApplicationRecord
    #Relationship with Assignment
    belongs_to :assignment

    #Relationship with User
    has_one :user
end
