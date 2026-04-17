class APITokensController < ApplicationController
  before_action :authenticated!
  before_action :authenticate_user
  before_action :set_course
  before_action :ensure_instructor_role
  before_action :set_pending_request_count

  def index
    @api_tokens = @course.api_tokens.includes(:user).order(created_at: :desc)
  end

  def destroy
    @api_token = @course.api_tokens.find_by(id: params[:id])

    if @api_token
      @api_token.revoke!
      redirect_to course_api_tokens_path(@course), notice: 'API token revoked successfully.'
    else
      redirect_to course_api_tokens_path(@course), alert: 'API token not found.'
    end
  end

  private

  def set_pending_request_count
    @pending_requests_count = Request.where(course_id: @course&.id, status: 'pending').count
  end
end
