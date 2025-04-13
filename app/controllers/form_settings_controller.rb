class FormSettingsController < ApplicationController
  before_action :authenticate_user
  before_action :set_course

  def edit
    @side_nav = 'form_settings'
    @form_setting = @course.form_setting || @course.build_form_setting(
      documentation_desc: <<~DESC
        Please provide links to any additional details if relevant. Please do not include any personal health or disability related details in your documentation. If you have questions please reach out the course staff before submitting this form.
      DESC
    )
  end

  def update
    @form_setting = @course.form_setting || @course.build_form_setting
    if @form_setting.update(form_setting_params)
      redirect_to course_path(@course), notice: 'Form settings updated successfully.'
    else
      render :edit
    end
  end

  private

  def set_course
    @course = Course.find_by(id: params[:course_id])
    @role = @course.user_role(@user)
    return if @course

    flash[:alert] = 'Course not found.'
    redirect_to courses_path
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
