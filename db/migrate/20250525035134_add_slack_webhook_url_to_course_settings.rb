class AddSlackWebhookUrlToCourseSettings < ActiveRecord::Migration[7.1]
  def change
    add_column :course_settings, :slack_webhook_url, :string
  end
end
