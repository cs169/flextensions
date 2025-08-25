class AddOptionsToUsersToCourses < ActiveRecord::Migration[7.2]
  def change
    # When this is being run, this table will be very small.
    safety_assured do
      change_table :user_to_courses do |t|
        t.boolean :removed, default: false, null: false
        t.boolean :allow_extended_requests, default: false, null: false
      end
    end
  end
end
