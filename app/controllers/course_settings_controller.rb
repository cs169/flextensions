class CourseSettingsController < ApplicationController
  before_action :authenticated!
  before_action :authenticate_user
  before_action :set_course
  before_action :ensure_instructor_role
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

  # rubocop:disable Metrics/AbcSize
  def update
    @side_nav = 'course_settings'
    @course_settings = @course.course_settings || @course.build_course_settings

    if params[:reset_email_template].present?
      reset_email_templates
      redirect_to course_settings_path(@course, tab: 'email'), notice: 'Email templates reset to defaults.'
    elsif @course_settings.update(course_settings_params)
      if @course_settings.enable_slack_webhook_url &&
         @course_settings.slack_webhook_url.present? &&
         @course_settings.saved_change_to_slack_webhook_url?

        success = SlackNotifier.notify(
          ":wave: Slack notifications have been enabled for *#{@course.course_name}* (#{@course.course_code}). You will now receive updates here!",
          @course_settings.slack_webhook_url
        )
        unless success
          redirect_to course_settings_path(@course, tab: params[:tab]), alert: 'Failed to send Slack notification. Please check the webhook URL.'
          return
        end
        redirect_to course_settings_path(@course, tab: params[:tab]), notice: 'Course settings updated successfully. Check your Slack channel for Notifications.'
        return
      end
      redirect_to course_settings_path(@course, tab: params[:tab]), notice: 'Course settings updated successfully.'
    else
      flash[:alert] = "Failed to update course settings: #{@course_settings.errors.full_messages.to_sentence}"
      redirect_to course_settings_path(@course, tab: params[:tab])
    end
  end
  # rubocop:enable Metrics/AbcSize

  private

  def reset_email_templates
    @course_settings.update(
      email_subject: DEFAULT_EMAIL_SUBJECT,
      email_template: DEFAULT_EMAIL_TEMPLATE
    )
  end

  def course_settings_params
    params.require(:course_settings).permit(
      :enable_extensions,
      :auto_approve_days,
      :auto_approve_extended_request_days,
      :max_auto_approve,
      :enable_gradescope,
      :gradescope_course_url,
      :extend_late_due_date,
      :enable_emails,
      :reply_email,
      :email_subject,
      :email_template,
      :enable_slack_webhook_url,
      :slack_webhook_url
    )
  end

  def set_pending_request_count
    @pending_requests_count = Request.where(course_id: @course&.id, status: 'pending').count
  end
end
