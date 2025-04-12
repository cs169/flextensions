class AssignmentsController < ApplicationController
  before_action :set_assignment

  def toggle_enabled
    previous_status = @assignment.enabled
    @assignment.update(enabled: !@assignment.enabled)

    # Log the change in rails.log
    Rails.logger.info "Assignment ID: #{@assignment.id}, Name: #{@assignment.name}, Enabled: #{previous_status} -> #{@assignment.enabled}"

    render json: { success: true, enabled: @assignment.enabled }
  rescue StandardError => e
    Rails.logger.error "Failed to toggle assignment ID: #{@assignment.id}. Error: #{e.message}"
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end

  private

  def set_assignment
    @assignment = Assignment.find(params[:id])
  end
end