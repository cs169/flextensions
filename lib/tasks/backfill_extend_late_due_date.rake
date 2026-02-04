# frozen_string_literal: true

namespace :course_settings do
  desc 'Backfill extend_late_due_date setting for all existing courses (sets to true for all courses)'
  task backfill_extend_late_due_date: :environment do
    puts 'Starting backfill of extend_late_due_date setting for all courses...'

    total_courses = Course.count
    updated_count = 0
    skipped_count = 0
    created_count = 0

    Course.find_each do |course|
      if course.course_settings.nil?
        # Create course settings if they don't exist
        CourseSettings.create!(course: course, extend_late_due_date: true)
        created_count += 1
        puts "Created course settings for course #{course.id} (#{course.course_name})"
      elsif course.course_settings.extend_late_due_date.nil?
        # Update existing course settings if extend_late_due_date is nil
        course.course_settings.update!(extend_late_due_date: true)
        updated_count += 1
        puts "Updated course #{course.id} (#{course.course_name})"
      else
        skipped_count += 1
      end
    end

    puts "\nBackfill complete!"
    puts "Total courses: #{total_courses}"
    puts "Settings created: #{created_count}"
    puts "Settings updated: #{updated_count}"
    puts "Skipped (already set): #{skipped_count}"
  end
end
