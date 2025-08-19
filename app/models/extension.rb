# assignment_id: foreign key to local assignment
# student_email: requires another api request to find student data (sid is given in first response). This currently doesn't exist in CanvasFacade
# initial_due_date: also requires an api request to find assignment data (assignment id is given in first response)
# Note that the assignment.due_at shows the due date as it is for whoever's logged in (which if it's a teacher, should be the original due date) but the actual original due date is never saved anywhere
# new_due_date:
# external_extension_id:
# last_processed_by_id: Requires login/sessions to be properly implemented
# == Schema Information
#
# Table name: extensions
#
#  id                    :bigint           not null, primary key
#  initial_due_date      :datetime
#  new_due_date          :datetime
#  student_email         :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  assignment_id         :bigint
#  external_extension_id :string
#  last_processed_by_id  :bigint
#
# Indexes
#
#  index_extensions_on_assignment_id         (assignment_id)
#  index_extensions_on_last_processed_by_id  (last_processed_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (assignment_id => assignments.id)
#  fk_rails_...  (last_processed_by_id => users.id)
#
class Extension < ApplicationRecord
  # Relationship with Assignment
  belongs_to :assignment

  # Relationship with User
  has_one :user
end
