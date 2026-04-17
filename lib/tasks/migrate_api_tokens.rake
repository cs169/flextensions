namespace :api_tokens do
  desc 'Migrate existing readonly_api_token values to the new api_tokens table'
  task migrate_legacy_tokens: :environment do
    system_user = SystemUserService.ensure_auto_approval_user_exists

    courses = Course.where.not(readonly_api_token: [ nil, '' ])
    migrated = 0
    skipped = 0

    courses.find_each do |course|
      digest = APIToken.digest(course.readonly_api_token)

      if APIToken.exists?(token_digest: digest)
        skipped += 1
        next
      end

      APIToken.create!(
        course: course,
        user: system_user,
        token_digest: digest,
        read_only: true,
        expires_at: 1.year.from_now
      )
      migrated += 1
    end

    puts "Migration complete: #{migrated} tokens migrated, #{skipped} skipped (already exist)"
  end
end
