class UserToCoursesController < ApplicationController
  before_action :authenticate_user
  before_action :set_course
  before_action :ensure_course_admin

  def toggle_allow_extended_requests
    @enrollment = @course.user_to_courses.find(params[:id])

    if @enrollment.update(allow_extended_requests: params[:allow_extended_requests])
      render json: { success: true }, status: :ok
    else
      flash[:alert] = "Failed to update enrollment: #{@enrollment.errors.full_messages.to_sentence}"
      render json: { redirect_to: course_path(@course) }, status: :unprocessable_entity
    end
  end

  private

  def ensure_course_admin
    enrollment = @course.user_to_courses.find_by(user: @user)
    return if enrollment&.course_admin?

    render json: { error: 'You must be an instructor or Lead TA.', redirect_to: course_path(@course) }, status: :forbidden
  end
end
