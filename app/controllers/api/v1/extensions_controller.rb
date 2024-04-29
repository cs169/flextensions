module Api
    module V1
      class ExtensionsController < BaseController
        before_action :set_facade
  
        def index
          render json: { message: 'not yet implemented'}, status: 501
        end
  
        def create
          find_extension_params
          #Get External Assignment object to find initial due date
          assignment_response = @canvas_facade.get_assignment(@course_to_lms.external_course_id.to_i, @assignment.external_assignment_id.to_i)
          if (assignment_response.status != 200)
            render json: assignment_response.to_json, status: 500
            return
          end
          assignment_json = JSON.parse(assignment_response.body)

          #Provision Extension
          response = @canvas_facade.provision_extension(@course_to_lms.external_course_id.to_i, params[:student_uid].to_i, @assignment.external_assignment_id.to_i, params[:new_due_date])
          if (response.success?) 
            assignment_override = JSON.parse(response.body)
            # if request succeeds, create a new Extension object

            #assignment_id: foreign key to local assignment
            #student_email: requires another api request to find student data (sid is given in first response). This currently doesn't exist in CanvasFacade
            #initial_due_date: also requires an api request to find assignment data (assignment id is given in first response)
            #Note that the assignment.due_at shows the due date as it is for whoever's logged in (which if it's a teacher, should be the original due date) but the actual original due date is never saved anywhere
            #new_due_date:
            #external_extension_id:
            #last_processed_by_id: Requires login/sessions to be properly implemented
            @extension = Extension.new(assignment_id: @assignment.id, student_email: nil, initial_due_date: assignment_json["due_at"], new_due_date: assignment_override["due_at"], external_extension_id: assignment_override["id"], last_processed_by_id: nil)
            if @extension.save
              render json: @extension.to_json, status: 200
            else
              render json: {"error": "Extension requested, but local save failed"}.to_json, status: 500
            end
          else
            render json: response.body, status: response.status
          end


        end
  
        def destroy
          render json: { message: 'not yet implemented'}, status: 501
        end
  
        private
  
        def set_facade
          Rails.logger.info "Using CANVAS_URL: #{ENV['CANVAS_URL']}"
          #not sure if auth key will be in the request headers or in cookie
          @canvas_facade = CanvasFacade.new(request.headers['Authorization'])
        end

        def find_extension_params
          @lms = Lms.find(params[:lms_id])
          @course = Course.find(params[:course_id])
          @assignment = Assignment.find(params[:assignment_id])
          @course_to_lms = CourseToLms.find(@assignment.course_to_lms_id)
        end
      end
    end
  end
