class FormSettingsController < ApplicationController
  before_action :authenticated!
  before_action :authenticate_user
  before_action :set_course
  before_action :ensure_instructor_role
  before_action :set_pending_request_count

  def edit
    @side_nav = 'form_settings'
    @form_setting = @course.form_setting
  end

  def update
    @side_nav = 'form_settings'
    @form_setting = @course.form_setting || @course.build_form_setting

    permitted = form_setting_params.to_h
    defaulted = {
      reason_desc: '',
      documentation_desc: '',
      documentation_disp: '',
      custom_q1: '',
      custom_q1_desc: '',
      custom_q1_disp: '',
      custom_q2: '',
      custom_q2_desc: '',
      custom_q2_disp: ''
    }.merge(permitted)

    if @form_setting.update(defaulted)
      redirect_to edit_course_form_setting_path(@course), notice: 'Form settings updated successfully.'
    else
      render :edit
    end
  end

  private

  def form_setting_params
    params.require(:form_setting).permit(
      :reason_desc, :documentation_desc, :documentation_disp,
      :custom_q1, :custom_q1_desc, :custom_q1_disp,
      :custom_q2, :custom_q2_desc, :custom_q2_disp
    )
  end

  def set_pending_request_count
    @pending_requests_count = Request.where(course_id: @course&.id, status: 'pending').count
  end
end
