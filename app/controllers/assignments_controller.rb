class AssignmentsController < ApplicationController
  def toggle_enabled
    @assignment = Assignment.find(params[:id])
    course = @assignment.course_to_lms.course
    course_settings = course.course_settings

    # Only allow enabling if course-level extensions are enabled
    if params[:enabled] == 'true' && (course_settings.nil? || !course_settings.enable_extensions)
      flash.now[:alert] = 'Extensions are disabled at the course level'
      # Return a successful response but with an error code

      render json: { redirect_to: course_path(course) }, status: :unprocessable_entity
      return
    end

    if @assignment.update(enabled: params[:enabled])
      render json: { success: true }, status: :ok
    else
      flash[:alert] = 'Failed to update assignment'
      render json: { redirect_to: course_path(course) }, status: :unprocessable_entity
    end
  end
end
