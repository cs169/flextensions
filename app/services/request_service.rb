class RequestService
  # Handle authentication for a specific course
  def self.authenticate_course(course, redirect_path)
    return true if course

    { redirect_to: redirect_path, alert: 'Course not found.' }
  end

  # Check instructor permission
  def self.check_instructor_permission(role, course_path)
    return true if role == 'instructor'

    { redirect_to: course_path, alert: 'You do not have permission to perform this action.' }
  end

  # Ensure extensions are enabled for students
  def self.check_extensions_enabled_for_students(role, course, redirect_path)
    return true unless role == 'student'

    course_settings = course.course_settings
    return true unless course_settings && !course_settings.enable_extensions

    { redirect_to: redirect_path, alert: 'Extensions are not enabled for this course.' }
  end

  # Ensure a request is in pending status
  def self.ensure_request_is_pending(request, course_path)
    if request.nil?
      { redirect_to: course_path, alert: 'Request not found.' }
    elsif request.status != 'pending'
      { redirect_to: course_path, alert: 'This action can only be performed on pending requests.' }
    else
      true
    end
  end

  # Set course role from settings
  def self.set_course_role_from_settings(course_id, user)
    course = Course.find_by(id: course_id)
    if course
      role = course.user_role(user)
      form_settings = course&.form_setting
      { course: course, role: role, form_settings: form_settings }
    else
      { redirect_to: Rails.application.routes.url_helpers.courses_path, alert: 'Course not found.' }
    end
  end

  # Helper to determine view based on role
  def self.render_role_based_view(role, ctrl, act, options = {})
    view = options[:view] || act
    instructor_view = "#{ctrl}/instructor_#{view}"
    student_view = "#{ctrl}/student_#{view}"

    case role
    when 'instructor'
      { render: instructor_view }
    when 'student'
      { render: student_view }
    else
      { redirect_to: Rails.application.routes.url_helpers.courses_path,
        alert: 'You do not have access to this course.' }
    end
  end

  # Authenticate a user from session
  def self.authenticate_user(session_user_id)
    user = User.find_by(canvas_uid: session_user_id)
    return { user: user } if user

    { redirect_to: Rails.application.routes.url_helpers.root_path,
      alert: 'Please log in to access this page.' }
  end
end
