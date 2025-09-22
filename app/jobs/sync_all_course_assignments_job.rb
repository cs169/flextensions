class SyncAllCourseAssignmentsJob < ApplicationJob
  queue_as :default

  def perform(course_to_lms_id, sync_user_id)
    # TODO: Replace this with just the course idea, then find all linked LMS.
    course_to_lms = CourseToLms.find(course_to_lms_id)
    sync_user = User.find(sync_user_id)
    course = Course.find(course_to_lms.course_id)

    # TODO: This isn't great if we fire off two distinct jobs...
    results = {
      added_assignments: 0,
      updated_assignments: 0,
      unchanged_assignments: 0,
      deleted_assignments: 0
    }

    # Get the corresponding LMS syncer
    syncer = get_syncer(course_to_lms.lms_id)
    lms_assignments = syncer.fetch_assignments(course_to_lms, sync_user)

    # Keep track of external assignment IDs from LMS
    external_assignment_ids = lms_assignments.map(&:id)

    # Sync or update assignments
    lms_assignments.each do |lms_assignment|
      sync_assignment(course_to_lms, lms_assignment, results, syncer)
    end

    # Delete assignments that no longer exist in LMS
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
  def sync_assignment(course_to_lms, lms_assignment, results, syncer)
    assignment = Assignment.find_or_initialize_by(course_to_lms_id: course_to_lms.id, external_assignment_id: lms_assignment.id)
    assignment.name = lms_assignment.name

    # syncer populate assignment details
    syncer.populate_assignment(assignment, lms_assignment)

    if assignment.new_record?
      results[:added_assignments] += 1
    elsif assignment.changed?
      results[:updated_assignments] += 1
    else
      results[:unchanged_assignments] += 1
    end
    assignment.save!
  end

  def get_syncer(lms_id)
    case lms_id
    when 1
      Lmss::Canvas::AssignmentSyncer.new
    when 2
      Lmss::Gradescope::AssignmentSyncer.new
    else
      raise "Unsupported LMS ID: #{lms_id}"
    end
  end
end
