class AddPendingNotificationToCourseSettings < ActiveRecord::Migration[7.2]
  def change
    safety_assured do
      change_table :course_settings, bulk: true do |t|
        t.string :pending_notification_frequency, default: nil
        t.string :pending_notification_email, default: nil
      end
    end
  end
end
