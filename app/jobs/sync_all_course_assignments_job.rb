class SyncAllCourseAssignmentsJob < ApplicationJob
  queue_as :default

  def perform(course_to_lms_id, token)
    course_to_lms = CourseToLms.find(course_to_lms_id)

    # Fetch assignments from Canvas
    assignments = course_to_lms.get_all_canvas_assignments(token)

    # Keep track of external assignment IDs from Canvas
    external_assignment_ids = assignments.pluck('id')

    # Sync or update assignments
    assignments.each do |assignment_data|
      sync_assignment(course_to_lms, assignment_data)
    end

    # Delete assignments that no longer exist in Canvas
    Assignment.where(course_to_lms_id: course_to_lms.id)
              .where.not(external_assignment_id: external_assignment_ids)
              .destroy_all
  end

  private

  # Sync a single assignment
  def sync_assignment(course_to_lms, assignment_data)
    assignment = Assignment.find_or_initialize_by(course_to_lms_id: course_to_lms.id, external_assignment_id: assignment_data['id'])
    assignment.name = assignment_data['name']

    # Extract due_at and lock_at dates
    assignment.due_date = extract_date_field(assignment_data, 'due_at')
    assignment.late_due_date = extract_date_field(assignment_data, 'lock_at')

    assignment.save!
  end

  # Helper method to extract dates from assignment data
  def extract_date_field(assignment_data, field_name)
    if assignment_data['base_date'] && assignment_data['base_date'][field_name].present?
      DateTime.parse(assignment_data['base_date'][field_name])
    elsif assignment_data[field_name].present?
      DateTime.parse(assignment_data[field_name])
    end
  end
end
