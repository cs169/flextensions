module Api
    module V1
      class ExtensionsController < BaseController
        before_action :set_facade
  
        def index
          response = @canvas_facade.get_all_courses
          render json: response.body, status: response.status
        end
  
        def create
          response = @canvas_facade.provision_extension(
            params[:course_id].to_i,
            params[:student_uid].to_i,
            params[:assignment_id].to_i,
            params[:new_due_date]
          )
          render json: response.body, status: response.status
        end
  
        def destroy
          response = @canvas_facade.delete_assignment_override(
            params[:course_id].to_i,
            params[:assignment_id].to_i,
            params[:override_id].to_i
          )
          render json: response.body, status: response.status
        end
  
        private
  
        def set_facade
          Rails.logger.info "Using CANVAS_URL: #{ENV['CANVAS_URL']}"
          @canvas_facade = CanvasFacade.new(request.headers['Authorization'])
        end
      end
    end
  end
