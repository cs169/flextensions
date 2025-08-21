
class StatusController < ApplicationController
  skip_before_action :authenticated!

  def health_check
    # TODO: Consider if an API call to canvas makes sense here
    render json: { status: 'ok', **check_database }
  end

  def version
    git_commit = fetch_git_commit
    git_commit_time = fetch_git_commit_time
    puma_start_time = fetch_puma_start_time
    server_time = Time.zone.now

    render json: {
      git_commit: git_commit,
      puma_start_time: puma_start_time,
      server_time: server_time
    }
  end

  private

  def check_database
    ActiveRecord::Base.connection.execute('SELECT 1')
    { database: true }
  rescue => e
    { database: false, error: e.message }
  end

  def fetch_git_commit
    ENV['GIT_COMMIT'] || ENV['HEROKU_SLUG_COMMIT'] || `git rev-parse HEAD`.strip.presence || nil
  rescue StandardError
    'unknown'
  end

  def fetch_puma_start_time
    restart_file = Rails.root.join('tmp/restart.txt')
    if File.exist?(restart_file)
      File.mtime(restart_file)
    else
      nil
    end
  end
end
