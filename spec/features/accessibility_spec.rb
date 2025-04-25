# rubocop:disable RSpec/MultipleMemoizedHelpers, RSpec/IndexedLet, RSpec/LetSetup
require 'rails_helper'
require 'rack_session_access/capybara'

RSpec.describe 'Accessibility', :a11y, :js, type: :feature do
  let(:chrome_data_dir) { ENV['CHROME_DATA_DIR'] || Dir.mktmpdir }

  # Create teachers (2)
  let!(:teacher1) { User.create!(email: 'teacher1@example.com', canvas_uid: '101', name: 'Teacher One') }
  let!(:teacher2) { User.create!(email: 'teacher2@example.com', canvas_uid: '102', name: 'Teacher Two') }

  # Create students (4)
  let!(:student1) { User.create!(email: 'student1@example.com', canvas_uid: '201', name: 'Student One') }
  let!(:student2) { User.create!(email: 'student2@example.com', canvas_uid: '202', name: 'Student Two') }
  let!(:student3) { User.create!(email: 'student3@example.com', canvas_uid: '203', name: 'Student Three') }
  let!(:student4) { User.create!(email: 'student4@example.com', canvas_uid: '204', name: 'Student Four') }

  # Create courses (3)
  let!(:course1) { Course.create!(course_name: 'Math 101', canvas_id: '301', course_code: 'MATH101') }
  let!(:course2) { Course.create!(course_name: 'English 201', canvas_id: '302', course_code: 'ENG201') }
  let!(:course3) { Course.create!(course_name: 'Computer Science 301', canvas_id: '303', course_code: 'CS301') }

  # Create LMS
  let!(:lms) { Lms.create!(lms_name: 'Canvas', use_auth_token: true) }

  # Create CourseToLms connections for each course
  let!(:course_to_lms1) { CourseToLms.create!(course: course1, lms_id: lms.id, external_course_id: '301') }
  let!(:course_to_lms2) { CourseToLms.create!(course: course2, lms_id: lms.id, external_course_id: '302') }
  let!(:course_to_lms3) { CourseToLms.create!(course: course3, lms_id: lms.id, external_course_id: '303') }

  # Create 5 assignments for each course (15 total)
  # Course 1 Assignments
  let!(:c1_assignment1) { Assignment.create!(name: 'Math Quiz 1', course_to_lms_id: course_to_lms1.id, external_assignment_id: 'math_q1', enabled: true, due_date: 7.days.from_now, late_due_date: 10.days.from_now) }
  let!(:c1_assignment2) { Assignment.create!(name: 'Math Homework 1', course_to_lms_id: course_to_lms1.id, external_assignment_id: 'math_hw1', enabled: true, due_date: 14.days.from_now, late_due_date: 16.days.from_now) }
  let!(:c1_assignment3) { Assignment.create!(name: 'Math Midterm', course_to_lms_id: course_to_lms1.id, external_assignment_id: 'math_mid', enabled: true, due_date: 21.days.from_now, late_due_date: 21.days.from_now) }
  let!(:c1_assignment4) { Assignment.create!(name: 'Math Homework 2', course_to_lms_id: course_to_lms1.id, external_assignment_id: 'math_hw2', enabled: true, due_date: 28.days.from_now, late_due_date: 30.days.from_now) }
  let!(:c1_assignment5) { Assignment.create!(name: 'Math Final', course_to_lms_id: course_to_lms1.id, external_assignment_id: 'math_final', enabled: true, due_date: 35.days.from_now, late_due_date: 35.days.from_now) }

  # Course 2 Assignments
  let!(:c2_assignment1) { Assignment.create!(name: 'English Essay 1', course_to_lms_id: course_to_lms2.id, external_assignment_id: 'eng_e1', enabled: true, due_date: 8.days.from_now, late_due_date: 12.days.from_now) }
  let!(:c2_assignment2) { Assignment.create!(name: 'English Reading 1', course_to_lms_id: course_to_lms2.id, external_assignment_id: 'eng_r1', enabled: true, due_date: 15.days.from_now, late_due_date: 17.days.from_now) }
  let!(:c2_assignment3) { Assignment.create!(name: 'English Midterm', course_to_lms_id: course_to_lms2.id, external_assignment_id: 'eng_mid', enabled: true, due_date: 22.days.from_now, late_due_date: 22.days.from_now) }
  let!(:c2_assignment4) { Assignment.create!(name: 'English Essay 2', course_to_lms_id: course_to_lms2.id, external_assignment_id: 'eng_e2', enabled: true, due_date: 29.days.from_now, late_due_date: 31.days.from_now) }
  let!(:c2_assignment5) { Assignment.create!(name: 'English Final', course_to_lms_id: course_to_lms2.id, external_assignment_id: 'eng_final', enabled: true, due_date: 36.days.from_now, late_due_date: 36.days.from_now) }

  # Course 3 Assignments
  let!(:c3_assignment1) { Assignment.create!(name: 'CS Project 1', course_to_lms_id: course_to_lms3.id, external_assignment_id: 'cs_p1', enabled: true, due_date: 9.days.from_now, late_due_date: 11.days.from_now) }
  let!(:c3_assignment2) { Assignment.create!(name: 'CS Lab 1', course_to_lms_id: course_to_lms3.id, external_assignment_id: 'cs_l1', enabled: true, due_date: 16.days.from_now, late_due_date: 18.days.from_now) }
  let!(:c3_assignment3) { Assignment.create!(name: 'CS Midterm', course_to_lms_id: course_to_lms3.id, external_assignment_id: 'cs_mid', enabled: true, due_date: 23.days.from_now, late_due_date: 23.days.from_now) }
  let!(:c3_assignment4) { Assignment.create!(name: 'CS Project 2', course_to_lms_id: course_to_lms3.id, external_assignment_id: 'cs_p2', enabled: true, due_date: 30.days.from_now, late_due_date: 32.days.from_now) }
  let!(:c3_assignment5) { Assignment.create!(name: 'CS Final', course_to_lms_id: course_to_lms3.id, external_assignment_id: 'cs_final', enabled: true, due_date: 37.days.from_now, late_due_date: 37.days.from_now) }

  # Create enrollments - enroll teachers and students in courses
  # Teacher enrollments
  let!(:teacher1_course1) { UserToCourse.create!(user: teacher1, course: course1, role: 'teacher') }
  let!(:teacher1_course2) { UserToCourse.create!(user: teacher1, course: course2, role: 'teacher') }
  let!(:teacher2_course3) { UserToCourse.create!(user: teacher2, course: course3, role: 'teacher') }

  # Student enrollments
  let!(:student1_course1) { UserToCourse.create!(user: student1, course: course1, role: 'student') }
  let!(:student1_course2) { UserToCourse.create!(user: student1, course: course2, role: 'student') }
  let!(:student2_course1) { UserToCourse.create!(user: student2, course: course1, role: 'student') }
  let!(:student2_course3) { UserToCourse.create!(user: student2, course: course3, role: 'student') }
  let!(:student3_course2) { UserToCourse.create!(user: student3, course: course2, role: 'student') }
  let!(:student3_course3) { UserToCourse.create!(user: student3, course: course3, role: 'student') }
  let!(:student4_course1) { UserToCourse.create!(user: student4, course: course1, role: 'student') }
  let!(:student4_course3) { UserToCourse.create!(user: student4, course: course3, role: 'student') }

  # Create extension requests (15 total)
  # Course 1 extension requests
  let!(:c1_request1) { Request.create!(course_id: course1.id, user_id: student1.id, assignment_id: c1_assignment1.id, reason: 'Medical emergency', status: 'approved', requested_due_date: 12.days.from_now) }
  let!(:c1_request2) { Request.create!(course_id: course1.id, user_id: student2.id, assignment_id: c1_assignment2.id, reason: 'Family emergency', status: 'pending', requested_due_date: 18.days.from_now) }
  let!(:c1_request3) { Request.create!(course_id: course1.id, user_id: student4.id, assignment_id: c1_assignment3.id, reason: 'Technical issues', status: 'denied', requested_due_date: 23.days.from_now) }
  let!(:c1_request4) { Request.create!(course_id: course1.id, user_id: student1.id, assignment_id: c1_assignment4.id, reason: 'Work conflict', status: 'pending', requested_due_date: 32.days.from_now) }
  let!(:c1_request5) { Request.create!(course_id: course1.id, user_id: student2.id, assignment_id: c1_assignment5.id, reason: 'Mental health', status: 'pending', requested_due_date: 38.days.from_now) }

  # Course 2 extension requests
  let!(:c2_request1) { Request.create!(course_id: course2.id, user_id: student1.id, assignment_id: c2_assignment1.id, reason: 'Technology failure', status: 'approved', requested_due_date: 13.days.from_now) }
  let!(:c2_request2) { Request.create!(course_id: course2.id, user_id: student3.id, assignment_id: c2_assignment2.id, reason: 'Illness', status: 'pending', requested_due_date: 19.days.from_now) }
  let!(:c2_request3) { Request.create!(course_id: course2.id, user_id: student1.id, assignment_id: c2_assignment3.id, reason: 'Academic conflict', status: 'denied', requested_due_date: 24.days.from_now) }
  let!(:c2_request4) { Request.create!(course_id: course2.id, user_id: student3.id, assignment_id: c2_assignment4.id, reason: 'Personal emergency', status: 'pending', requested_due_date: 33.days.from_now) }
  let!(:c2_request5) { Request.create!(course_id: course2.id, user_id: student3.id, assignment_id: c2_assignment5.id, reason: 'Travel issues', status: 'approved', requested_due_date: 39.days.from_now) }

  # Course 3 extension requests
  let!(:c3_request1) { Request.create!(course_id: course3.id, user_id: student2.id, assignment_id: c3_assignment1.id, reason: 'Injury', status: 'approved', requested_due_date: 14.days.from_now) }
  let!(:c3_request2) { Request.create!(course_id: course3.id, user_id: student3.id, assignment_id: c3_assignment2.id, reason: 'Death in family', status: 'approved', requested_due_date: 20.days.from_now) }
  let!(:c3_request3) { Request.create!(course_id: course3.id, user_id: student4.id, assignment_id: c3_assignment3.id, reason: 'Computer crash', status: 'pending', requested_due_date: 25.days.from_now) }
  let!(:c3_request4) { Request.create!(course_id: course3.id, user_id: student2.id, assignment_id: c3_assignment4.id, reason: 'Job interview', status: 'denied', requested_due_date: 34.days.from_now) }
  let!(:c3_request5) { Request.create!(course_id: course3.id, user_id: student4.id, assignment_id: c3_assignment5.id, reason: 'Conference attendance', status: 'pending', requested_due_date: 40.days.from_now) }

  # Create form settings and course settings for each course
  let!(:form_setting1) do
    FormSetting.create!(
      course_id: course1.id,
      reason_desc: 'Please provide your reason for requesting an extension',
      documentation_desc: 'Please provide any supporting documentation',
      documentation_disp: 'optional',
      custom_q1_disp: 'hidden',
      custom_q2_disp: 'hidden'
    )
  end

  let!(:form_setting2) do
    FormSetting.create!(
      course_id: course2.id,
      reason_desc: 'Explain why you need an extension',
      documentation_desc: 'Upload any supporting documents',
      documentation_disp: 'required',
      custom_q1_disp: 'optional',
      custom_q2_disp: 'hidden',
      custom_q1: 'Have you contacted your TA about this?'
    )
  end

  let!(:form_setting3) do
    FormSetting.create!(
      course_id: course3.id,
      reason_desc: 'Provide detailed reason for extension request',
      documentation_desc: 'Documentation is required for all requests',
      documentation_disp: 'required',
      custom_q1_disp: 'required',
      custom_q2_disp: 'optional',
      custom_q1: 'Have you discussed this with your group members?',
      custom_q2: 'Will this delay affect your other coursework?'
    )
  end

  let!(:course_settings1) { CourseSettings.create!(course_id: course1.id, enable_extensions: true, auto_approve_days: 2) }
  let!(:course_settings2) { CourseSettings.create!(course_id: course2.id, enable_extensions: true, auto_approve_days: 1) }
  let!(:course_settings3) { CourseSettings.create!(course_id: course3.id, enable_extensions: true, auto_approve_days: 3) }

  # Create some extensions for testing
  let!(:extension1) { Extension.create!(assignment_id: c1_assignment1.id, student_email: student1.email, initial_due_date: c1_assignment1.due_date, new_due_date: 12.days.from_now) }
  let!(:extension2) { Extension.create!(assignment_id: c2_assignment1.id, student_email: student1.email, initial_due_date: c2_assignment1.due_date, new_due_date: 13.days.from_now) }
  let!(:extension3) { Extension.create!(assignment_id: c3_assignment1.id, student_email: student2.email, initial_due_date: c3_assignment1.due_date, new_due_date: 14.days.from_now) }

  # Helper methods for testing different user roles
  def mock_teacher_login
    page.set_rack_session(user_id: teacher1.canvas_uid)
  end

  def mock_student_login
    page.set_rack_session(user_id: student1.canvas_uid)
  end

  # Set theme helper
  def set_theme(theme)
    page.execute_script("document.documentElement.setAttribute('data-bs-theme', '#{theme}')")
    expect(page.evaluate_script("document.documentElement.getAttribute('data-bs-theme')")).to eq(theme)
  end

  before do
    WebMock.allow_net_connect!

    Capybara.register_driver :selenium_chrome do |app|
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument("--user-data-dir=#{chrome_data_dir}")
      options.add_argument('--headless=new')
      options.add_argument('--no-sandbox')
      options.add_argument('--disable-dev-shm-usage')
      options.add_argument('--disable-gpu')
      options.add_argument('--disable-extensions')
      options.add_argument('--disable-infobars')
      options.add_argument('--window-size=1400,1400')

      Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
    end

    Capybara.javascript_driver = :selenium_chrome

    # Create credentials for API calls
    teacher1.lms_credentials.create!(
      lms_name: 'canvas',
      token: 'fake_token',
      refresh_token: 'fake_refresh_token',
      expire_time: 1.hour.from_now
    )

    student1.lms_credentials.create!(
      lms_name: 'canvas',
      token: 'fake_token',
      refresh_token: 'fake_refresh_token',
      expire_time: 1.hour.from_now
    )

    # Stub Canvas API calls
    stub_request(:get, %r{#{ENV.fetch('CANVAS_URL', 'https://canvas.example.com')}/api/v1/courses/.*})
      .to_return(status: 200, body: [].to_json)
  end

  after do
    begin
      Capybara.reset_sessions!
    rescue Selenium::WebDriver::Error::NoSuchWindowError, Selenium::WebDriver::Error::InvalidSessionIdError,
           Selenium::WebDriver::Error::UnknownError
      puts 'Browser session problem. Ignore it and proceed.'
    end
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  # Test with both themes
  %w[light dark].each do |theme|
    context "with #{theme} theme" do
      it 'Home page should be accessible for teacher', :a11y do
        mock_teacher_login
        visit '/'
        sleep 2
        set_theme(theme)
        sleep 1
        page.save_screenshot("home_#{theme}_teacher.png")
        expect(page).to be_axe_clean
      end

      it 'Home page should be accessible for student', :a11y do
        mock_student_login
        visit '/'
        sleep 2
        set_theme(theme)
        sleep 1
        page.save_screenshot("home_#{theme}_student.png")
        expect(page).to be_axe_clean
      end

      it 'Courses page should be accessible for teacher', :a11y do
        mock_teacher_login
        visit '/courses'
        sleep 2
        set_theme(theme)
        sleep 1
        page.save_screenshot("courses_#{theme}_teacher.png")
        expect(page).to be_axe_clean
      end

      it 'Courses page should be accessible for student', :a11y do
        mock_student_login
        visit '/courses'
        sleep 2
        set_theme(theme)
        sleep 1
        page.save_screenshot("courses_#{theme}_student.png")
        expect(page).to be_axe_clean
      end

      it 'New course page should be accessible for teacher', :a11y do
        mock_teacher_login
        visit '/courses/new'
        sleep 2
        set_theme(theme)
        sleep 1
        page.save_screenshot("new_course_#{theme}_teacher.png")
        expect(page).to be_axe_clean
      end

      it 'New course page should be accessible for student', :a11y do
        mock_student_login
        visit '/courses/new'
        sleep 2
        set_theme(theme)
        sleep 1
        page.save_screenshot("new_course_#{theme}_student.png")
        expect(page).to be_axe_clean
      end

      it 'Assignments page should be accessible for teacher', :a11y do
        mock_teacher_login
        visit "/courses/#{course1.id}"
        sleep 2
        set_theme(theme)
        sleep 1
        page.save_screenshot("assignments_#{theme}_teacher.png")
        expect(page).to be_axe_clean
      end

      it 'Assignments page should be accessible for student', :a11y do
        mock_student_login
        visit "/courses/#{course1.id}"
        sleep 2
        set_theme(theme)
        sleep 1
        page.save_screenshot("assignments_#{theme}_student.png")
        expect(page).to be_axe_clean
      end

      it 'Extension requests page should be accessible for student', :a11y do
        mock_student_login
        visit "/courses/#{course1.id}/requests"
        sleep 2
        set_theme(theme)
        sleep 1
        page.save_screenshot("extension_requests_#{theme}_student.png")
        expect(page).to be_axe_clean
      end

      it 'New extension request page should be accessible for student', :a11y do
        mock_student_login
        visit "/courses/#{course1.id}/requests/new"
        sleep 2
        set_theme(theme)
        sleep 1
        page.save_screenshot("new_extension_request_#{theme}_student.png")
        expect(page).to be_axe_clean
      end

      it 'Extension request details page should be accessible for student', :a11y do
        mock_student_login
        visit "/courses/#{course1.id}/requests/#{c1_request1.id}"
        sleep 2
        set_theme(theme)
        sleep 1
        page.save_screenshot("extension_request_details_#{theme}_student.png")
        expect(page).to be_axe_clean
      end

      it 'Edit extension request page should be accessible for student', :a11y do
        mock_student_login
        visit "/courses/#{course1.id}/requests/#{c1_request1.id}/edit"
        sleep 2
        set_theme(theme)
        sleep 1
        page.save_screenshot("edit_extension_request_#{theme}_student.png")
        expect(page).to be_axe_clean
      end

      it 'Login page should be accessible for student', :a11y do
        visit '/login'
        sleep 2
        set_theme(theme)
        sleep 1
        page.save_screenshot("login_#{theme}_student.png")
        expect(page).to be_axe_clean
      end

      it 'Course enrollments page should be accessible for teacher', :a11y do
        mock_teacher_login
        visit "/courses/#{course1.id}/enrollments"
        sleep 2
        set_theme(theme)
        sleep 1
        page.save_screenshot("course_enrollments_#{theme}_teacher.png")
        expect(page).to be_axe_clean
      end

      it 'Extension requests page should be accessible for teacher', :a11y do
        mock_teacher_login
        visit "/courses/#{course1.id}/requests"
        sleep 2
        set_theme(theme)
        sleep 1
        page.save_screenshot("extension_requests_#{theme}_teacher.png")
        expect(page).to be_axe_clean
      end

      it 'Course settings page should be accessible for teacher', :a11y do
        mock_teacher_login
        visit "/courses/#{course1.id}/edit?tab=general"
        sleep 2
        set_theme(theme)
        sleep 1
        page.save_screenshot("course_settings_#{theme}_teacher.png")
        expect(page).to be_axe_clean
      end

      it 'Course Email settings page should be accessible for teacher', :a11y do
        mock_teacher_login
        visit "/courses/#{course1.id}/edit?tab=email"
        sleep 2
        set_theme(theme)
        sleep 1
        page.save_screenshot("course_email_settings_#{theme}_teacher.png")
        expect(page).to be_axe_clean
      end

      it 'Edit form settings page should be accessible for teacher', :a11y do
        mock_teacher_login
        visit "/courses/#{course1.id}/form_setting/edit"
        sleep 2
        set_theme(theme)
        sleep 1
        page.save_screenshot("edit_form_settings_#{theme}_teacher.png")
        expect(page).to be_axe_clean
      end

      it 'Extension request details page should be accessible for teacher', :a11y do
        mock_teacher_login
        visit "/courses/#{course1.id}/requests/#{c1_request1.id}"
        sleep 2
        set_theme(theme)
        sleep 1
        page.save_screenshot("extension_request_details_#{theme}_teacher.png")
        expect(page).to be_axe_clean
      end

      it 'Login page should be accessible for teacher', :a11y do
        visit '/login'
        sleep 2
        set_theme(theme)
        sleep 1
        page.save_screenshot("login_#{theme}_teacher.png")
        expect(page).to be_axe_clean
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers, RSpec/IndexedLet, RSpec/LetSetup
