#!/usr/bin/env ruby

require 'faraday'
require 'json'

# Configuration
CANVAS_BASE_URL = 'https://ucberkeleysandbox.instructure.com'
ACCOUNT_ID = 1
TEACHER_USER_ID = 136

def get_token
  token = ENV.fetch('CANVAS_TOKEN', nil)
  return token unless token.nil?

  print 'Enter your Canvas API token: '
  gets.chomp
end

class CanvasAPI
  def initialize(base_url, token)
    @conn = Faraday.new(url: base_url) do |f|
      f.request :json
      f.response :json
      f.headers['Authorization'] = "Bearer #{token}"
    end
  end

  def create_course(name)
    response = @conn.post("/api/v1/accounts/#{ACCOUNT_ID}/courses") do |req|
      req.body = {
        course: {
          name: name,
          course_code: name.tr(' ', '_').upcase
        }
      }
    end

    response.body if response.success?
  end

  def add_teacher(course_id, user_id)
    response = @conn.post("/api/v1/courses/#{course_id}/enrollments") do |req|
      req.body = {
        enrollment: {
          user_id: user_id,
          type: 'TeacherEnrollment',
          enrollment_state: 'active'
        }
      }
    end

    response.body if response.success?
  end
end

# Main script
token = get_token
canvas = CanvasAPI.new(CANVAS_BASE_URL, token)

puts 'Creating 30 test courses...'

(1..30).each do |n|
  course_name = "Test Course #{n}"

  puts "Creating: #{course_name}"
  course = canvas.create_course(course_name)

  if course && course['id']
    puts "  Created course ID: #{course['id']}"

    enrollment = canvas.add_teacher(course['id'], TEACHER_USER_ID)
    if enrollment
      puts "  Added teacher (user #{TEACHER_USER_ID})"
    else
      puts '  Failed to add teacher'
    end
  else
    puts '  Failed to create course'
  end

  sleep(0.5) # Rate limiting
end

puts 'Done!'
