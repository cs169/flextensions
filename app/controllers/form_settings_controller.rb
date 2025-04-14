class FormSettingsController < ApplicationController
  before_action :authenticate_user
  before_action :set_course

  def edit
    @side_nav = 'form_settings'
    @form_setting = @course.form_setting || @course.create_form_setting(
      reason_desc: '',
      documentation_desc: '',
      documentation_disp: 'optional',
      custom_q1: '',
      custom_q1_desc: '',
      custom_q1_disp: 'hidden',
      custom_q2: '',
      custom_q2_desc: '',
      custom_q2_disp: 'hidden'
    )
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

  def set_course
    @course = Course.find_by(id: params[:course_id])
    unless @course
      flash[:alert] = 'Course not found.'
      redirect_to courses_path and return
    end

    @role = @course.user_role(@user)
    return if @role == 'instructor'

    flash[:alert] = 'You do not have permission to access this page.'
    redirect_to courses_path and return
  end

  def form_setting_params
    params.require(:form_setting).permit(
      :reason_desc, :documentation_desc, :documentation_disp,
      :custom_q1, :custom_q1_desc, :custom_q1_disp,
      :custom_q2, :custom_q2_desc, :custom_q2_disp
    )
  end

  def authenticate_user
    @user = User.find_by(canvas_uid: session[:user_id])
    return unless @user.nil?

    redirect_to root_path, alert: 'Please log in to access this page.'
  end
end
