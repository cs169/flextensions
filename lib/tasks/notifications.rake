namespace :notifications do
  desc 'Send pending request digest emails (usage: rake notifications:send_pending_digests[daily])'
  task :send_pending_digests, [:frequency] => :environment do |_t, args|
    frequency = args[:frequency]
    abort 'Usage: rake notifications:send_pending_digests[daily|weekly]' unless %w[daily weekly].include?(frequency)

    PendingRequestsNotificationJob.perform_now(frequency)
  end
end
