class AssignmentsController < ApplicationController
  before_action :set_assignment

  def toggle_enabled
    @assignment.update(enabled: !@assignment.enabled)
    render json: { success: true, enabled: @assignment.enabled }
  rescue StandardError => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end

  private

  def set_assignment
    @assignment = Assignment.find(params[:id])
  end
end