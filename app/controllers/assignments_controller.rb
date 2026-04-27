class AssignmentsController < ApplicationController
  def toggle_enabled
    @assignment = Assignment.find(params[:id])
    course = @assignment.course_to_lms.course
    @role = params[:role] || course&.user_role(@user)

    unless @role == 'instructor'
      Rails.logger.error "Role #{@role} does not have permission to toggle assignment enabled status"
      flash.now[:alert] = 'You do not have permission to perform this action.'
      return render json: { redirect_to: course_path(course) }, status: :forbidden
    end

    if @assignment.update(enabled: params[:enabled])
      render json: { success: true }, status: :ok
    else
      flash[:alert] = "Failed to update assignment: #{@assignment.errors.full_messages.to_sentence}"
      render json: { redirect_to: course_path(course) }, status: :unprocessable_content
    end
  end

  def bulk_update_enabled
    course = Course.find_by(id: params[:course_id])
    unless course
      return render json: { error: 'Course not found.' }, status: :not_found
    end

    @role = params[:role] || course.user_role(@user)

    unless @role == 'instructor'
      Rails.logger.error "Role #{@role} does not have permission to bulk toggle assignment enabled status"
      flash.now[:alert] = 'You do not have permission to perform this action.'
      return render json: { redirect_to: course_path(course) }, status: :forbidden
    end

    enabled = ActiveModel::Type::Boolean.new.cast(params[:enabled])

    scope = course.assignments
    if enabled
      eligible_scope = scope.where.not(due_date: nil)
      updated_count = eligible_scope.update_all(enabled: true)
      skipped_count = scope.count - updated_count
    else
      updated_count = scope.update_all(enabled: false)
      skipped_count = 0
    end

    render json: {
      success: true,
      enabled: enabled,
      updated_count: updated_count,
      skipped_count: skipped_count
    }, status: :ok
  end
end
