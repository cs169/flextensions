class SyncUsersFromCanvasJob < ApplicationJob
  queue_as :default

  # Optionally pass a status callback (block) to receive updates
  def perform(course_id, user_id, role_or_roles, &status_callback)
    results_by_role = {}
    course = Course.find(course_id)
    user = User.find(user_id)
    roles = Array(role_or_roles)

    roles.each do |role|
      status_callback&.call("syncing role: #{role}")
      results_by_role[role] = sync_users_for_role(course, user, role)
      status_callback&.call("finished syncing role: #{role}")
    end
    status_callback&.call('all roles synced')
    results_by_role[:synced_at] = Time.current

    course_to_lms = course.course_to_lms(1)
    course_to_lms.recent_roster_sync = results_by_role
    course_to_lms.save!
    results_by_role
  end

  private

  # Batch LMS Roster Sync
  # We rely on Postgres' upsert for performance
  # NOTE: This still skips model validations. That is probably OK.
  # rubocop:disable Rails/SkipsModelValidations
  def sync_users_for_role(course, user, role)
    token = user.ensure_fresh_canvas_token!
    canvas_users = CanvasFacade.new(token).get_all_course_users(course, role)
    if !canvas_users.is_a?(Array)
      Rails.logger.error "Unexpected response from Canvas API: #{canvas_users.inspect}"
      return { added: 0, removed: 0, updated: 0 }
    end
    current_canvas_user_ids = canvas_users.pluck('id').map(&:to_s)

    users_added = 0
    users_removed = 0
    users_updated = 0

    # Handle removals - only for the current role
    existing_role_enrollments = UserToCourse.joins(:user)
                                           .where(course_id: course.id, role: role)
                                           .select('user_to_courses.*, users.canvas_uid')

    enrollments_to_remove = existing_role_enrollments.reject do |utc|
      current_canvas_user_ids.include?(utc.canvas_uid)
    end

    if enrollments_to_remove.any?
      UserToCourse.where(id: enrollments_to_remove.map(&:id)).destroy_all
      users_removed = enrollments_to_remove.size
    end

    valid_canvas_users = canvas_users.reject { |user_data| user_data['email'].blank? }

    # Prepare user data for upsert - ensure canvas_uid is string
    users_to_upsert = valid_canvas_users.map do |user_data|
      {
        canvas_uid: user_data['id'].to_s,
        name: user_data['name'],
        email: user_data['email'],
        student_id: user_data['sis_user_id'],
        created_at: Time.current,
        updated_at: Time.current
      }
    end

    if users_to_upsert.any?
      # Track which users are new vs updated
      canvas_uid_strings = users_to_upsert.pluck(:canvas_uid)
      existing_canvas_uids = User.where(canvas_uid: canvas_uid_strings).pluck(:canvas_uid)
      new_user_count = users_to_upsert.count { |u| existing_canvas_uids.exclude?(u[:canvas_uid]) }

      User.upsert_all(
        users_to_upsert,
        unique_by: :canvas_uid,
        update_only: [ :name, :email, :student_id ]
      )

      users_added = new_user_count
      users_updated = users_to_upsert.size - new_user_count
    end

    # Get all users for enrollment creation
    canvas_uids = valid_canvas_users.map { |user_data| user_data['id'].to_s }
    users_by_canvas_uid = User.where(canvas_uid: canvas_uids).index_by(&:canvas_uid)

    # Get existing enrollments to avoid duplicates
    existing_user_ids = users_by_canvas_uid.values.map(&:id)
    existing_enrollments = UserToCourse.where(
      user_id: existing_user_ids,
      course_id: course.id,
      role: role
    ).pluck(:user_id).to_set

    # Prepare enrollment data for insert
    enrollments_to_create = valid_canvas_users.filter_map do |user_data|
      canvas_uid_str = user_data['id'].to_s
      user = users_by_canvas_uid[canvas_uid_str]
      next unless user
      next if existing_enrollments.include?(user.id) # Skip if enrollment already exists

      {
        user_id: user.id,
        course_id: course.id,
        role: role,
        created_at: Time.current,
        updated_at: Time.current
      }
    end

    if enrollments_to_create.any?
      begin
        UserToCourse.insert_all(enrollments_to_create)
      rescue => e
        Rails.logger.debug { "DEBUG: Insert failed: #{e.message}" }
        Rails.logger.debug { "DEBUG: #{e.backtrace.first(3)}" }
      end
    end

    {
      added: users_added,
      removed: users_removed,
      updated: users_updated
    }
  end
  # rubocop:enable Rails/SkipsModelValidations
end
