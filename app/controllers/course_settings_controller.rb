class CourseSettingsController < ApplicationController
  before_action :authenticated!
  before_action :authenticate_user
  before_action :set_course
  before_action :set_pending_request_count
  before_action :authorize_instructor

  def update
    @side_nav = 'edit'
    @course_setting = @course.course_setting || @course.build_course_setting

    # Get the current parameters and the previous state
    setting_params = course_setting_params
    was_enabled = @course_setting.persisted? && @course_setting.enable_student_requests

    # If course is being enabled for the first time, add default templates
    if setting_params[:enable_student_requests] == '1' && !was_enabled
      setting_params[:email_subject] ||= 'Extension Request Status: {{status}} - {{course_code}}'
      setting_params[:email_template] ||= default_email_template
    end

    if @course_setting.update(setting_params)
      redirect_to edit_course_path(@course), notice: 'Course settings updated successfully.'
    else
      redirect_to edit_course_path(@course), alert: 'Failed to update course settings.'
    end
  end

  private

  def set_course
    @course = Course.find_by(id: params[:course_id])
    if @course.nil?
      flash[:alert] = 'Course not found.'
      redirect_to courses_path
      return
    end
    @role = @course.user_role(@user)
  end

  def course_setting_params
    params.require(:course_setting).permit(
      :enable_student_requests, :auto_approve_days, :auto_approve_dsp_days,
      :max_auto_approve, :reply_email, :email_subject, :email_template, :enable_emails
    )
  end

  def authenticate_user
    @user = User.find_by(canvas_uid: session[:user_id])
    return unless @user.nil?

    redirect_to root_path, alert: 'User not found in the database.'
  end

  def authorize_instructor
    return if @role == 'instructor'

    redirect_to course_path(@course), alert: 'You do not have permission to update course settings.'
  end

  def default_email_template
    <<~TEMPLATE
      Dear {{student_name}},

      Your extension request for {{assignment_name}} in {{course_name}} ({{course_code}}) has been {{status}}.

      Extension Details:
      - Original Due Date: {{original_due_date}}
      - New Due Date: {{new_due_date}}
      - Extension Days: {{extension_days}}

      If you have any questions, please contact the course staff.

      Best regards,
      {{course_name}} Staff
    TEMPLATE
  end
end
