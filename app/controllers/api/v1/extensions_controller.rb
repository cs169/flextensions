module Api
    module V1
      class ExtensionsController < BaseController
        before_action :set_facade
  
        def index
          response = @canvas_facade.get_all_courses
          render json: response.body, status: response.status
        end
  
        def create
          @course = Course.find(params[:course_id])
          @assignment = Assignment.find(params[:assignment_id])
          response = @canvas_facade.provision_extension(
            @course.external_course_id.to_i,
            params[:student_uid].to_i,
            @assignment.external_assignment_id.to_i,
            params[:new_due_date]
          )

          if (response.status == 200)
            assignment_override = response.body
            # if request succeeds, create a new Extension object
            @extension = Extension.new(
            assignment_id: @assignment.id # foreign key to local assignment
            student_email: nil # requires another api request to find student data (sid is given in first response)
            initial_due_date: nil # also requires an api request to find assignment data (assignment id is given in first response)
            new_due_date: assignment_override["due_at"]
            external_extension_id: assignment_override["id"]
            )
            if @extension.save
              render json: @extension.to_json, status: 200
            else
              render status: 500
            end
          else
            render json: response.body, status: response.status
          end


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
