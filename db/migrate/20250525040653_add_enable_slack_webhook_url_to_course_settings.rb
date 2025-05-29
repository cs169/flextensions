class AddEnableSlackWebhookUrlToCourseSettings < ActiveRecord::Migration[7.1]
  def change
    add_column :course_settings, :enable_slack_webhook_url, :boolean
  end
end
