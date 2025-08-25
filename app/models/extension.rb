# TODO: 2025-08: This model was never used. It should be deleted/removed.
# The `request` model is now what is used.

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
