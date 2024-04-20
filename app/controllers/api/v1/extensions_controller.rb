module Api
    module V1
      class ExtensionsController < BaseController
        before_action :set_facade
  
        def index
          #Incorrect.
          response = @canvas_facade.get_all_courses
          render json: response.body, status: response.status
        end
  
        def create
          @lms = Lms.where(lms_name: "canvas")
          @course = Course.find(params[:course_id])
          @assignment = Assignment.find(params[:assignment_id])
          @course_to_lms = CourseToLms.where(lms_id: @lms.id, course_id: @course.id).take
          response = @canvas_facade.provision_extension(
            @course_to_lms.external_course_id.to_i,
            params[:student_uid].to_i,
            @assignment.external_assignment_id.to_i,
            params[:new_due_date]
          )

          if (response.status == 200) 
            assignment_override = response.body
            # if request succeeds, create a new Extension object
            assignment_response = @canvas_facade.get_assignment(@course_to_lms.external_course_id.to_i, @assignment.external_assignment_id.to_i)
            if (assignment_response.status != 200)
              render json: assignment_response.to_json, status: 500
              return
            end
            @extension = Extension.new(
            assignment_id: @assignment.id, # foreign key to local assignment
            student_email: nil, # requires another api request to find student data (sid is given in first response)
            initial_due_date: assignment_response.body["due_at"], # also requires an api request to find assignment data (assignment id is given in first response)
            #Note that the assignment.due_at shows the due date as it is for whoever's logged in (which if it's a teacher, should be the original due date) but the actual original due date is never saved anywhere
            new_due_date: assignment_override["due_at"],
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
          #needs updating with external ids
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
          #not sure if auth key will be in the request headers or in cookie
          @canvas_facade = CanvasFacade.new(request.headers['Authorization'])
        end
      end
    end
  end
