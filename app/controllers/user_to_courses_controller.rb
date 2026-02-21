class UserToCoursesController < ApplicationController
  before_action :authenticate_user
  before_action :set_course

  def toggle_allow_extended_requests
    @enrollment = @course.user_to_courses.find(params[:id])

    unless @role == 'instructor'
      Rails.logger.error "Role #{@role} does not have permission to toggle allow_extended_requests"
      flash.now[:alert] = 'You do not have permission to perform this action.'
      return render json: { redirect_to: course_path(@course) }, status: :forbidden
    end

    if @enrollment.update(allow_extended_requests: params[:allow_extended_requests])
      render json: { success: true }, status: :ok
    else
      flash[:alert] = "Failed to update enrollment: #{@enrollment.errors.full_messages.to_sentence}"
      render json: { redirect_to: course_path(@course) }, status: :unprocessable_entity
    end
  end
end
