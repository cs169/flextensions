# rubocop:disable RSpec/MultipleMemoizedHelpers, RSpec/IndexedLet, RSpec/LetSetup
require 'rails_helper'
require 'rack_session_access/capybara'

RSpec.describe 'Accessibility', :a11y, :js, type: :feature do

  let(:chrome_data_dir) { ENV['CHROME_DATA_DIR'] || Dir.mktmpdir }

  let!(:teacher1) { create(:user, email: 'teacher1@example.com', canvas_uid: '101', name: 'Teacher One') }
  let!(:teacher2) { create(:user, email: 'teacher2@example.com', canvas_uid: '102', name: 'Teacher Two') }

  let!(:student1) { create(:user, email: 'student1@example.com', canvas_uid: '201', name: 'Student One') }
  let!(:student2) { create(:user, email: 'student2@example.com', canvas_uid: '202', name: 'Student Two') }
  let!(:student3) { create(:user, email: 'student3@example.com', canvas_uid: '203', name: 'Student Three') }
  let!(:student4) { create(:user, email: 'student4@example.com', canvas_uid: '204', name: 'Student Four') }

  let!(:course1) { create(:course, course_name: 'Math 101', canvas_id: '301', course_code: 'MATH101') }
  let!(:course2) { create(:course, course_name: 'English 201', canvas_id: '302', course_code: 'ENG201') }
  let!(:course3) { create(:course, course_name: 'Computer Science 301', canvas_id: '303', course_code: 'CS301') }

  let(:lms) { Lms.find(1) }

  let!(:course_to_lms1) { create(:course_to_lms, course: course1, lms: lms, external_course_id: '301') }
  let!(:course_to_lms2) { create(:course_to_lms, course: course2, lms: lms, external_course_id: '302') }
  let!(:course_to_lms3) { create(:course_to_lms, course: course3, lms: lms, external_course_id: '303') }

  let!(:c1_assignment1) { create(:assignment, name: 'Math Quiz 1', course_to_lms: course_to_lms1, external_assignment_id: 'math_q1', due_date: 7.days.from_now, late_due_date: 10.days.from_now) }
  let!(:c1_assignment2) { create(:assignment, name: 'Math Homework 1', course_to_lms: course_to_lms1, external_assignment_id: 'math_hw1', due_date: 14.days.from_now, late_due_date: 16.days.from_now) }
  let!(:c1_assignment3) { create(:assignment, name: 'Math Midterm', course_to_lms: course_to_lms1, external_assignment_id: 'math_mid', due_date: 21.days.from_now, late_due_date: 21.days.from_now) }
  let!(:c1_assignment4) { create(:assignment, name: 'Math Homework 2', course_to_lms: course_to_lms1, external_assignment_id: 'math_hw2', due_date: 28.days.from_now, late_due_date: 30.days.from_now) }
  let!(:c1_assignment5) { create(:assignment, name: 'Math Final', course_to_lms: course_to_lms1, external_assignment_id: 'math_final', due_date: 35.days.from_now, late_due_date: 35.days.from_now) }

  let!(:c2_assignment1) { create(:assignment, name: 'English Essay 1', course_to_lms: course_to_lms2, external_assignment_id: 'eng_e1', due_date: 8.days.from_now, late_due_date: 12.days.from_now) }
  let!(:c2_assignment2) { create(:assignment, name: 'English Reading 1', course_to_lms: course_to_lms2, external_assignment_id: 'eng_r1', due_date: 15.days.from_now, late_due_date: 17.days.from_now) }
  let!(:c2_assignment3) { create(:assignment, name: 'English Midterm', course_to_lms: course_to_lms2, external_assignment_id: 'eng_mid', due_date: 22.days.from_now, late_due_date: 22.days.from_now) }
  let!(:c2_assignment4) { create(:assignment, name: 'English Essay 2', course_to_lms: course_to_lms2, external_assignment_id: 'eng_e2', due_date: 29.days.from_now, late_due_date: 31.days.from_now) }
  let!(:c2_assignment5) { create(:assignment, name: 'English Final', course_to_lms: course_to_lms2, external_assignment_id: 'eng_final', due_date: 36.days.from_now, late_due_date: 36.days.from_now) }

  let!(:c3_assignment1) { create(:assignment, name: 'CS Project 1', course_to_lms: course_to_lms3, external_assignment_id: 'cs_p1', due_date: 9.days.from_now, late_due_date: 11.days.from_now) }
  let!(:c3_assignment2) { create(:assignment, name: 'CS Lab 1', course_to_lms: course_to_lms3, external_assignment_id: 'cs_l1', due_date: 16.days.from_now, late_due_date: 18.days.from_now) }
  let!(:c3_assignment3) { create(:assignment, name: 'CS Midterm', course_to_lms: course_to_lms3, external_assignment_id: 'cs_mid', due_date: 23.days.from_now, late_due_date: 23.days.from_now) }
  let!(:c3_assignment4) { create(:assignment, name: 'CS Project 2', course_to_lms: course_to_lms3, external_assignment_id: 'cs_p2', due_date: 30.days.from_now, late_due_date: 32.days.from_now) }
  let!(:c3_assignment5) { create(:assignment, name: 'CS Final', course_to_lms: course_to_lms3, external_assignment_id: 'cs_final', due_date: 37.days.from_now, late_due_date: 37.days.from_now) }

  let!(:teacher1_course1) { create(:user_to_course, user: teacher1, course: course1, role: 'teacher') }
  let!(:teacher1_course2) { create(:user_to_course, user: teacher1, course: course2, role: 'teacher') }
  let!(:teacher2_course3) { create(:user_to_course, user: teacher2, course: course3, role: 'teacher') }

  let!(:student1_course1) { create(:user_to_course, user: student1, course: course1, role: 'student') }
  let!(:student1_course2) { create(:user_to_course, user: student1, course: course2, role: 'student') }
  let!(:student2_course1) { create(:user_to_course, user: student2, course: course1, role: 'student') }
  let!(:student2_course3) { create(:user_to_course, user: student2, course: course3, role: 'student') }
  let!(:student3_course2) { create(:user_to_course, user: student3, course: course2, role: 'student') }
  let!(:student3_course3) { create(:user_to_course, user: student3, course: course3, role: 'student') }
  let!(:student4_course1) { create(:user_to_course, user: student4, course: course1, role: 'student') }
  let!(:student4_course3) { create(:user_to_course, user: student4, course: course3, role: 'student') }

  let!(:c1_request1) { create(:request, :approved, course: course1, user: student1, assignment: c1_assignment1, reason: 'Medical emergency', requested_due_date: 12.days.from_now) }
  let!(:c1_request2) { create(:request, course: course1, user: student2, assignment: c1_assignment2, reason: 'Family emergency', requested_due_date: 18.days.from_now) }
  let!(:c1_request3) { create(:request, :denied, course: course1, user: student4, assignment: c1_assignment3, reason: 'Technical issues', requested_due_date: 23.days.from_now) }
  let!(:c1_request4) { create(:request, course: course1, user: student1, assignment: c1_assignment4, reason: 'Work conflict', requested_due_date: 32.days.from_now) }
  let!(:c1_request5) { create(:request, course: course1, user: student2, assignment: c1_assignment5, reason: 'Mental health', requested_due_date: 38.days.from_now) }

  let!(:c2_request1) { create(:request, :approved, course: course2, user: student1, assignment: c2_assignment1, reason: 'Technology failure', requested_due_date: 13.days.from_now) }
  let!(:c2_request2) { create(:request, course: course2, user: student3, assignment: c2_assignment2, reason: 'Illness', requested_due_date: 19.days.from_now) }
  let!(:c2_request3) { create(:request, :denied, course: course2, user: student1, assignment: c2_assignment3, reason: 'Academic conflict', requested_due_date: 24.days.from_now) }
  let!(:c2_request4) { create(:request, course: course2, user: student3, assignment: c2_assignment4, reason: 'Personal emergency', requested_due_date: 33.days.from_now) }
  let!(:c2_request5) { create(:request, :approved, course: course2, user: student3, assignment: c2_assignment5, reason: 'Travel issues', requested_due_date: 39.days.from_now) }

  let!(:c3_request1) { create(:request, :approved, course: course3, user: student2, assignment: c3_assignment1, reason: 'Injury', requested_due_date: 14.days.from_now) }
  let!(:c3_request2) { create(:request, :approved, course: course3, user: student3, assignment: c3_assignment2, reason: 'Death in family', requested_due_date: 20.days.from_now) }
  let!(:c3_request3) { create(:request, course: course3, user: student4, assignment: c3_assignment3, reason: 'Computer crash', requested_due_date: 25.days.from_now) }
  let!(:c3_request4) { create(:request, :denied, course: course3, user: student2, assignment: c3_assignment4, reason: 'Job interview', requested_due_date: 34.days.from_now) }
  let!(:c3_request5) { create(:request, course: course3, user: student4, assignment: c3_assignment5, reason: 'Conference attendance', requested_due_date: 40.days.from_now) }

  let!(:form_setting1) do
    create(:form_setting,
           course: course1,
           reason_desc: 'Please provide your reason for requesting an extension',
           documentation_desc: 'Please provide any supporting documentation',
           documentation_disp: 'optional')
  end

  let!(:form_setting2) do
    create(:form_setting,
           course: course2,
           reason_desc: 'Explain why you need an extension',
           documentation_desc: 'Upload any supporting documents',
           documentation_disp: 'required',
           custom_q1_disp: 'optional',
           custom_q1: 'Have you contacted your TA about this?')
  end

  let!(:form_setting3) do
    create(:form_setting,
           course: course3,
           reason_desc: 'Provide detailed reason for extension request',
           documentation_desc: 'Documentation is required for all requests',
           documentation_disp: 'required',
           custom_q1_disp: 'required',
           custom_q2_disp: 'optional',
           custom_q1: 'Have you discussed this with your group members?',
           custom_q2: 'Will this delay affect your other coursework?')
  end

  let!(:course_settings1) { create(:course_settings, course: course1, auto_approve_days: 2) }
  let!(:course_settings2) { create(:course_settings, course: course2, auto_approve_days: 1) }
  let!(:course_settings3) { create(:course_settings, course: course3, auto_approve_days: 3) }

  let!(:extension1) { create(:extension, assignment: c1_assignment1, student_email: student1.email, initial_due_date: c1_assignment1.due_date, new_due_date: 12.days.from_now) }
  let!(:extension2) { create(:extension, assignment: c2_assignment1, student_email: student1.email, initial_due_date: c2_assignment1.due_date, new_due_date: 13.days.from_now) }
  let!(:extension3) { create(:extension, assignment: c3_assignment1, student_email: student2.email, initial_due_date: c3_assignment1.due_date, new_due_date: 14.days.from_now) }

  def mock_teacher_login
    page.set_rack_session(user_id: teacher1.canvas_uid)
  end

  def mock_student_login
    page.set_rack_session(user_id: student1.canvas_uid)
  end

  def set_theme(theme)
    page.execute_script("document.documentElement.setAttribute('data-bs-theme', '#{theme}')")
    expect(page.evaluate_script("document.documentElement.getAttribute('data-bs-theme')")).to eq(theme)
  end

  def test_page_accessibility(path, user_type = :teacher, theme = 'light', screenshot_name = nil)
    user_type == :teacher ? mock_teacher_login : mock_student_login

    visit path
    wait_for_page_to_load
    set_theme(theme)

    screenshot_name ||= "#{path.tr('/', '_')}_#{theme}_#{user_type}.png"
    page.save_screenshot(screenshot_name)
  end

  # Helper for waiting for page load
  def wait_for_page_to_load
    Timeout.timeout(2) do
      sleep(0.1) until page.evaluate_script('document.readyState') == 'complete'
    end
  rescue Timeout::Error
    sleep(1)
  end

  before(:all) do
    Lms.find_or_create_by!(id: 1, lms_name: 'canvas', use_auth_token: true)
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

    # Set a default wait time
    Capybara.default_max_wait_time = 3

    create(:lms_credential, user: teacher1, lms_name: 'canvas')
    create(:lms_credential, user: student1, lms_name: 'canvas')

    stub_request(:get, %r{#{ENV.fetch('CANVAS_URL')}/api/v1/courses/.*})
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
        test_page_accessibility('/', :teacher, theme, "home_#{theme}_teacher.png")
        expect(page).to be_axe_clean
      end

      it 'Home page should be accessible for student', :a11y do
        test_page_accessibility('/', :student, theme, "home_#{theme}_student.png")
        expect(page).to be_axe_clean
      end

      it 'Courses page should be accessible for teacher', :a11y do
        test_page_accessibility('/courses', :teacher, theme, "courses_#{theme}_teacher.png")
        expect(page).to be_axe_clean
      end

      it 'Courses page should be accessible for student', :a11y do
        test_page_accessibility('/courses', :student, theme, "courses_#{theme}_student.png")
        expect(page).to be_axe_clean
      end

      it 'Course details page should be accessible for teacher', :a11y do
        test_page_accessibility("/courses/#{course1.id}", :teacher, theme, "course_details_#{theme}_teacher.png")
        expect(page).to be_axe_clean
      end

      it 'Course details page should be accessible for student', :a11y do
        test_page_accessibility("/courses/#{course1.id}", :student, theme, "course_details_#{theme}_student.png")
        expect(page).to be_axe_clean
      end

      it 'New course page should be accessible for teacher', :a11y do
        test_page_accessibility('/courses/new', :teacher, theme, "new_course_#{theme}_teacher.png")
        expect(page).to be_axe_clean
      end

      it 'New course page should be accessible for student', :a11y do
        test_page_accessibility('/courses/new', :student, theme, "new_course_#{theme}_student.png")
        expect(page).to be_axe_clean
      end

      it 'Course settings page should be accessible for teacher', :a11y do
        test_page_accessibility("/courses/#{course1.id}/edit?tab=general", :teacher, theme, "course_settings_#{theme}_teacher.png")
        expect(page).to be_axe_clean
      end

      it 'Course Email settings page should be accessible for teacher', :a11y do
        test_page_accessibility("/courses/#{course1.id}/edit?tab=email", :teacher, theme, "course_email_settings_#{theme}_teacher.png")
        expect(page).to be_axe_clean
      end

      it 'Course enrollments page should be accessible for teacher', :a11y do
        test_page_accessibility("/courses/#{course1.id}/enrollments", :teacher, theme, "course_enrollments_#{theme}_teacher.png")
        expect(page).to be_axe_clean
      end

      it 'New extension request page should be accessible for student', :a11y do
        test_page_accessibility("/courses/#{course1.id}/requests/new", :student, theme, "new_extension_request_#{theme}_student.png")
        expect(page).to be_axe_clean
      end

      it 'Extension requests page should be accessible for teacher', :a11y do
        test_page_accessibility("/courses/#{course1.id}/requests", :teacher, theme, "extension_requests_#{theme}_teacher.png")
        expect(page).to be_axe_clean
      end

      it 'Extension requests page should be accessible for student', :a11y do
        test_page_accessibility("/courses/#{course1.id}/requests", :student, theme, "extension_requests_#{theme}_student.png")
        expect(page).to be_axe_clean
      end

      it 'Extension request details page should be accessible for teacher', :a11y do
        test_page_accessibility("/courses/#{course1.id}/requests/#{c1_request1.id}", :teacher, theme, "extension_request_details_#{theme}_teacher.png")
        expect(page).to be_axe_clean
      end

      it 'Extension request details page should be accessible for student', :a11y do
        test_page_accessibility("/courses/#{course1.id}/requests/#{c1_request1.id}", :student, theme, "extension_request_details_#{theme}_student.png")
        expect(page).to be_axe_clean
      end

      it 'Edit extension request page should be accessible for student', :a11y do
        test_page_accessibility("/courses/#{course1.id}/requests/#{c1_request1.id}/edit", :student, theme, "edit_extension_request_#{theme}_student.png")
        expect(page).to be_axe_clean
      end

      it 'Edit form settings page should be accessible for teacher', :a11y do
        test_page_accessibility("/courses/#{course1.id}/form_setting/edit", :teacher, theme, "edit_form_settings_#{theme}_teacher.png")
        expect(page).to be_axe_clean
      end

      it 'Assignments page should be accessible for teacher', :a11y do
        test_page_accessibility("/courses/#{course1.id}", :teacher, theme, "assignments_#{theme}_teacher.png")
        expect(page).to be_axe_clean
      end

      it 'Assignments page should be accessible for student', :a11y do
        test_page_accessibility("/courses/#{course1.id}", :student, theme, "assignments_#{theme}_student.png")
        expect(page).to be_axe_clean
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers, RSpec/IndexedLet, RSpec/LetSetup
