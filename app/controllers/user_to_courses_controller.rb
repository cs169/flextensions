class UserToCoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course
  before_action :set_enrollment
  before_action :authorize_instructor!

  def toggle_allow_extended_requests
    if @enrollment.update(allow_extended_requests: params[:allow_extended_requests])
      render json: { success: true }, status: :ok
    else
      render json: {
        success: false,
        errors: @enrollment.errors.full_messages,
        redirect_to: courses_path
      }, status: :unprocessable_entity
    end
  end

  private

  def authenticate_user!
    user_id = session[:user_id]
    @current_user = User.find_by(canvas_uid: user_id) if user_id
    redirect_to root_path unless @current_user
  end

  def set_course
    @course = Course.find_by(id: params[:course_id])
    unless @course
      flash[:alert] = 'Course not found.'
      redirect_to courses_path
    end
  end

  def set_enrollment
    @enrollment = UserToCourse.find(params[:id])
  end

  def authorize_instructor!
    user_to_course = UserToCourse.find_by(user: @current_user, course: @course)
    unless user_to_course&.course_admin?
      render json: {
        success: false,
        error: 'Forbidden',
        redirect_to: courses_path
      }, status: :forbidden
    end
  end
end
