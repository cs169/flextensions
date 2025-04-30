class AssignmentsController < ApplicationController
  def toggle_enabled
    @assignment = Assignment.find(params[:id])
    course = @assignment.course_to_lms.course
    @role = params[:role] || course&.user_role(@user) # Use the passed role or fallback to determining it
    @user = User.find(params[:user_id]) if params[:user_id] # Optionally find the user if user_id is passed

    unless @role == 'instructor'
      Rails.logger.error "Role #{@role} does not have permission to toggle assignment enabled status"
      flash.now[:alert] = 'You do not have permission to perform this action.'
      return render json: { redirect_to: course_path(course) }, status: :forbidden
    end

    if @assignment.update(enabled: params[:enabled])
      render json: { success: true }, status: :ok
    else
      flash[:alert] = 'Failed to update assignment'
      render json: { redirect_to: course_path(course) }, status: :unprocessable_entity
    end
  end
end
