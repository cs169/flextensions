class SyncAllCourseAssignmentsJob < ApplicationJob
  queue_as :default

  def perform(course_to_lms_id, sync_user_id)
    course_to_lms = CourseToLms.find(course_to_lms_id)
    sync_user = User.find(sync_user_id)
    course = Course.find(course_to_lms.course_id)

    results = {
      added_assignments: 0,
      updated_assignments: 0,
      unchanged_assignments: 0,
      deleted_assignments: 0
    }

    # Fetch assignments from Canvas
    assignments = course_to_lms.get_all_canvas_assignments(sync_user)

    # Keep track of external assignment IDs from Canvas
    external_assignment_ids = assignments.pluck('id')

    # Sync or update assignments
    assignments.each do |assignment_data|
      sync_assignment(course_to_lms, assignment_data, results)
    end

    # Delete assignments that no longer exist in Canvas
    deleted_assignments = Assignment.where(course_to_lms_id: course_to_lms.id)
                                     .where.not(external_assignment_id: external_assignment_ids)
    deleted_assignments.destroy_all

    results[:deleted_assignments] = deleted_assignments.count
    results[:synced_at] = Time.current

    course_to_lms.recent_assignment_sync = results
    course_to_lms.save!
    results
  end

  private

  # Sync a single assignment
  def sync_assignment(course_to_lms, assignment_data, results)
    assignment = Assignment.find_or_initialize_by(course_to_lms_id: course_to_lms.id, external_assignment_id: assignment_data['id'])
    assignment.name = assignment_data['name']

    # Extract due_at and lock_at dates
    assignment.due_date = extract_date_field(assignment_data, 'due_at')
    assignment.late_due_date = extract_date_field(assignment_data, 'lock_at')

    if assignment.new_record?
      results[:added_assignments] += 1
    elsif assignment.changed?
      results[:updated_assignments] += 1
    else
      results[:unchanged_assignments] += 1
    end
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
