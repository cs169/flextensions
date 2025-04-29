class AssignmentsController < ApplicationController
  def toggle_enabled
    @assignment = Assignment.find(params[:id])
    course = @assignment.course_to_lms.course

    if @assignment.update(enabled: params[:enabled])
      render json: { success: true }, status: :ok
    else
      flash[:alert] = 'Failed to update assignment'
      render json: { redirect_to: course_path(course) }, status: :unprocessable_entity
    end
  end
end
