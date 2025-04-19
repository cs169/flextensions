class CourseSettingsController < ApplicationController
  before_action :authenticated!
  before_action :authenticate_user
  before_action :set_course
  before_action :set_pending_request_count

  # Default template settings
  DEFAULT_EMAIL_SUBJECT = 'Extension Request Status: {{status}} - {{course_code}}'.freeze
  DEFAULT_EMAIL_TEMPLATE = "Dear {{student_name}},\n\n
  Your extension request for {{assignment_name}} in {{course_name}} ({{course_code}}) has been {{status}}.
  \n\nExtension Details:
  \n- Original Due Date: {{original_due_date}}
  \n- New Due Date: {{new_due_date}}
  \n- Extension Days: {{extension_days}}
  \n\nIf you have any questions, please contact the course staff.
  \n\nBest regards,
  \n{{course_name}} Staff".freeze

  def update
    @side_nav = 'course_settings'
    @course_settings = @course.course_settings || @course.build_course_settings

    if params[:reset_email_template].present?
      reset_email_templates
      redirect_to course_settings_path(@course, tab: 'email'), notice: 'Email templates reset to defaults.'
    elsif @course_settings.update(course_settings_params)
      # Use the tab from params to determine which tab to show
      redirect_to course_settings_path(@course, tab: params[:tab]), notice: 'Course settings updated successfully.'
    else
      redirect_to course_settings_path(@course, tab: params[:tab]), alert: 'Failed to update course settings.'
    end
  end

  private

  def reset_email_templates
    @course_settings.update(
      email_subject: DEFAULT_EMAIL_SUBJECT,
      email_template: DEFAULT_EMAIL_TEMPLATE
    )
  end

  def set_course
    @course = Course.find_by(id: params[:course_id])
    if @course.nil?
      flash[:alert] = 'Course not found.'
      redirect_to courses_path
      return
    end
    @role = @course.user_role(@user)
  end

  def course_settings_params
    params.require(:course_settings).permit(
      :enable_extensions,
      :auto_approve_days,
      :auto_approve_dsp_days,
      :max_auto_approve,
      :enable_emails,
      :reply_email,
      :email_subject,
      :email_template
    )
  end

  def authenticate_user
    @user = User.find_by(canvas_uid: session[:user_id])
    return unless @user.nil?

    redirect_to root_path, alert: 'User not found in the database.'
  end

  def set_pending_request_count
    @pending_requests_count = Request.where(course_id: @course&.id, status: 'pending').count
  end
end
