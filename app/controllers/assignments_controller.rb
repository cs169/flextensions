class AssignmentsController < ApplicationController
    def toggle_enabled
        @assignment = Assignment.find(params[:id])
        @assignment.update(enabled: params[:enabled])
        head :ok
    end
end