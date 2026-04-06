require 'rails_helper'
require 'rake'

RSpec.describe 'notifications:send_pending_digests' do
  before(:all) do
    Rails.application.load_tasks
  end

  it 'invokes PendingRequestsNotificationJob with valid frequency' do
    expect(PendingRequestsNotificationJob).to receive(:perform_now).with('daily')
    Rake::Task['notifications:send_pending_digests'].reenable
    Rake::Task['notifications:send_pending_digests'].invoke('daily')
  end

  it 'aborts with usage message for invalid frequency' do
    Rake::Task['notifications:send_pending_digests'].reenable
    expect {
      Rake::Task['notifications:send_pending_digests'].invoke('monthly')
    }.to raise_error(SystemExit)
  end
end
