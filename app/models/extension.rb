# assignment_id: foreign key to local assignment
# student_email: requires another api request to find student data (sid is given in first response). This currently doesn't exist in CanvasFacade
# initial_due_date: also requires an api request to find assignment data (assignment id is given in first response)
# Note that the assignment.due_at shows the due date as it is for whoever's logged in (which if it's a teacher, should be the original due date) but the actual original due date is never saved anywhere
# new_due_date:
# external_extension_id:
# last_processed_by_id: Requires login/sessions to be properly implemented
class Extension < ApplicationRecord
    #Relationship with Assignment
    belongs_to :assignment

    #Relationship with User
    has_one :user
end
