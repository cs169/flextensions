# frozen_string_literal: true

namespace :courses do
  desc 'Backfill semester for existing courses by fetching term data from Canvas'
  task backfill_semester: :environment do
    puts 'Starting backfill of semester for all courses...'

    total = Course.count
    updated_count = 0
    skipped_count = 0
    failed_count = 0

    Course.find_each do |course|
      if course.semester.present?
        skipped_count += 1
        next
      end

      # Find a staff user with Canvas credentials to make the API call
      staff_user = course.staff_user_for_auto_approval
      if staff_user.nil?
        puts "No staff user found for course #{course.id} (#{course.course_name}) - skipping"
        failed_count += 1
        next
      end

      token = staff_user.canvas_token
      if token.blank?
        puts "No Canvas token for staff user on course #{course.id} (#{course.course_name}) - skipping"
        failed_count += 1
        next
      end

      begin
        response = CanvasFacade.new(token).get_course(course.canvas_id)
        if response&.success?
          data = JSON.parse(response.body)
          semester = data.dig('term', 'name')
          if semester.present?
            course.update!(semester: semester)
            updated_count += 1
            puts "Updated course #{course.id} (#{course.course_name}) -> #{semester}"
          else
            puts "No term data for course #{course.id} (#{course.course_name}) - skipping"
            failed_count += 1
          end
        else
          puts "API request failed for course #{course.id} (#{course.course_name}) - skipping"
          failed_count += 1
        end
      rescue StandardError => e
        puts "Error for course #{course.id} (#{course.course_name}): #{e.message}"
        failed_count += 1
      end
    end

    puts "\nBackfill complete!"
    puts "Total courses: #{total}"
    puts "Updated: #{updated_count}"
    puts "Skipped (already set): #{skipped_count}"
    puts "Failed: #{failed_count}"
  end
end
