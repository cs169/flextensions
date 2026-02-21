
# Canvas
Lms.find_or_create_by!(id: 1, lms_name: 'Canvas', use_auth_token: true)

# Gradescope
Lms.find_or_create_by!(id: 2, lms_name: 'Gradescope', use_auth_token: false)

# A special user to track auto-approvals of requests.
User.find_or_create_by!(
  email: SystemUserService::AUTO_APPROVAL_EMAIL,
  name: SystemUserService::AUTO_APPROVAL_NAME,
  canvas_uid: SystemUserService::AUTO_APPROVAL_UID
)

# Developer test users. you can use teacher or student
if Rails.env.development?
  # Teacher user for managing courses
  teacher_user = User.find_or_create_by!(email: 'teacher@example.com') do |u|
    u.name = 'Test Teacher'
    u.admin = false
    u.canvas_uid = 'teacher@example.com'
  end

  # Student user for requesting extensions
  student_user = User.find_or_create_by!(email: 'student@example.com') do |u|
    u.name = 'Test Student'
    u.admin = false
    u.canvas_uid = 'student@example.com'
  end

  # Create a single test course
  test_course = Course.find_or_create_by!(course_code: 'DEV101') do |c|
    c.course_name = 'Development Test Course'
    c.canvas_id = 'dev-course-001'
  end

  # Link test course to Canvas LMS
  CourseToLms.find_or_create_by!(course_id: test_course.id, lms_id: 1) do |ctl|
    ctl.external_course_id = 'dev-course-001'
  end

  # Enroll teacher as instructor
  UserToCourse.find_or_create_by!(user_id: teacher_user.id, course_id: test_course.id) do |utc|
    utc.role = 'teacher'
  end

  # Enroll student as student
  UserToCourse.find_or_create_by!(user_id: student_user.id, course_id: test_course.id) do |utc|
    utc.role = 'student'
  end

  # Enable extensions for test course
  CourseSettings.find_or_create_by!(course_id: test_course.id) do |cs|
    cs.enable_extensions = true
  end

  # Create form settings for test course
  FormSetting.find_or_create_by!(course_id: test_course.id) do |fs|
    fs.documentation_disp = 'optional'
    fs.custom_q1_disp = 'optional'
    fs.custom_q2_disp = 'optional'
  end

  # Create sample assignments for test course
  course_lms = CourseToLms.find_by(course_id: test_course.id, lms_id: 1)

  if course_lms
    Assignment.find_or_create_by!(course_to_lms_id: course_lms.id, external_assignment_id: 'dev-hw-1') do |a|
      a.name = 'Homework'
      a.due_date = 3.days.from_now
      a.late_due_date = 10.days.from_now
      a.enabled = true
    end
  end
end
