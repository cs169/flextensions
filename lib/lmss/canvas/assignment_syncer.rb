module Lmss
  module Canvas
    class AssignmentSyncer
      def fetch_assignments(course_to_lms, sync_user)
        raw_assignments = course_to_lms.get_all_canvas_assignments(sync_user)
        raw_assignments.map { |data| Lmss::Canvas::Assignment.new(data) }
      end

      def populate_assignment(assignment_model, lms_assignment)
        assignment_model.name = lms_assignment.name
        assignment_model.due_date = lms_assignment.due_date
        assignment_model.late_due_date = lms_assignment.late_due_date
        assignment_model.external_assignment_id = lms_assignment.id
      end
    end
  end
end
