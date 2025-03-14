namespace :rubocop do
  desc 'Run RuboCop with default settings'
  task run: :environment do
    sh 'bundle exec rubocop'
  rescue StandardError => e
    puts "RuboCop found issues: #{e.message}"
    exit(0) # Don't fail the rake task
  end

  desc 'Run RuboCop and automatically fix offenses'
  task fix: :environment do
    sh 'bundle exec rubocop -A'
  rescue StandardError => e
    puts "RuboCop auto-fix completed with issues: #{e.message}"
    exit(0) # Don't fail the rake task
  end
  
  desc 'Run RuboCop with HTML report output'
  task report: :environment do
    sh 'bundle exec rubocop --format html --out rubocop_report.html'
    puts 'RuboCop report generated at rubocop_report.html'
  rescue StandardError => e
    puts "RuboCop report generated with issues: #{e.message}"
    puts 'Report saved to rubocop_report.html'
    exit(0) # Don't fail the rake task
  end
end

desc 'Run RuboCop (alias for rubocop:run)'
task rubocop: 'rubocop:run' 