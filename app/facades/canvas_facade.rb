require 'date'
require 'faraday'
require 'json'
require 'ostruct'

# This is the facade for Canvas.
class CanvasFacade < LmsFacade
  class CanvasAPIError < LmsFacade::LmsAPIError; end

  CANVAS_URL = ENV.fetch('CANVAS_URL', nil)

  # Canvas instances can scope the flextensions developer key.
  # There must be one scope for each endpoint we can use.
  # This may not exceed 8000 characters in length, typically ~110 total scopes.
  # Pass these to the `scope` parameter of the `canvas_authorize_url` method.
  # This list must exactly match the scopes enabled for the Canvas developer key.
  # https://ucberkeleysandbox.instructure.com/accounts/1/developer_keys#api_key_modal_opened
  # Verify the scope which are on a key easily by querying the Canvas API:
  # curl -X GET \
  #   -H "Authorization: Bearer <your_access_token>" \
  #   "https://ucberkeleysandbox.instructure.com/api/v1/accounts/1/developer_keys/
  # NOTE: When using omniauth-canvas, the following scope is **required**:
  # url:GET|/api/v1/users/:user_id/profile
  # Without this, Canvas returns a horribly opaque error about invalid scopes, even if they match.
  #
  # Whenever a new scope is added, it must be added to the Canvas developer key **FIRST**,
  # especially in the production environment. You will likely want to use feature flags
  # and coordination with Berkeley to ensure that the scopes are added to the developer key.
  # NOTE: This is read into the OmniAuth initializer in `config/initializers/omniauth.rb`.
  # If you change this list, you will need to restart the Rails server.
  CANVAS_API_SCOPES = [
    # Scopes are sorted by the order in which they appear on the API Key edit modal.
    # Assignments
    'url:GET|/api/v1/courses/:course_id/assignments/:assignment_id/overrides',
    'url:POST|/api/v1/courses/:course_id/assignments/:assignment_id/overrides',
    'url:GET|/api/v1/courses/:course_id/assignments/overrides',
    'url:POST|/api/v1/courses/:course_id/assignments/overrides',
    'url:GET|/api/v1/courses/:course_id/assignments/:assignment_id/overrides/:id',
    'url:PUT|/api/v1/courses/:course_id/assignments/:assignment_id/overrides/:id',
    'url:DELETE|/api/v1/courses/:course_id/assignments/:assignment_id/overrides/:id',
    # Assignments - Bulk Operations
    'url:GET|/api/v1/courses/:course_id/assignments',
    'url:PUT|/api/v1/courses/:course_id/assignments/overrides',
    'url:POST|/api/v1/courses/:course_id/assignments/overrides',
    # Assignment Date Extension Details
    'url:GET|/api/v1/courses/:course_id/assignments/:assignment_id/date_details',
    'url:GET|/api/v1/courses/:course_id/quizzes/:quiz_id/date_details',
    # Assignments - Basic Info
    'url:GET|/api/v1/courses/:course_id/assignments',
    'url:GET|/api/v1/courses/:course_id/assignments/:id',
    'url:GET|/api/v1/courses/:course_id/assignments/:assignment_id/users/:user_id/group_members',
    # Courses
    # Note: /courses is scoped to the current user.
    'url:GET|/api/v1/courses',
    'url:GET|/api/v1/courses/:id',
    'url:GET|/api/v1/courses/:course_id/users',
    # Quiz Assignment Overrides
    'url:GET|/api/v1/courses/:course_id/quizzes/assignment_overrides',
    'url:GET|/api/v1/courses/:course_id/new_quizzes/assignment_overrides',
    # Users
    'url:GET|/api/v1/users/:user_id/profile',
    'url:GET|/api/v1/users/:id'
  ].join(' ')

  # Potential future scopes:
  # Assignment extensions, for addtional attempts
  # url:GET|/api/v1/users/:user_id/enrollments
  # url:GET|/api/v1/courses/:course_id/enrollments
  # For PL integration
  # url:GET|/api/v1/courses/:course_id/quizzes/:quiz_id/ip_filters
  # url:POST|/api/v1/courses/:course_id/assignments/:assignment_id/extensions
  # url:GET|/api/v1/sections/:course_section_id/assignments/:assignment_id/override
  # url:POST|/api/v1/courses/:course_id/quizzes/:quiz_id/extensions
  # url:GET|/api/v1/courses/:id/late_policy
  # url:POST|/api/v1/courses/:id/late_policy
  # url:PATCH|/api/v1/courses/:id/late_policy

  def auth_header
    { Authorization: "Bearer #{@api_token}" }
  end

  ##
  # Configures the facade with the canvas api endpoint configured in the environment.
  #
  # @param [String]              masqueradeToken the token of the user to masquerade as.
  # @param [Faraday::Connection] existing connection to use (defaults to nil).
  # Enable this to automatically parse JSON responses.
  # This will require some refactoring (and rebuilding VCRs/webmock)
  # do |faraday|
  #     faraday.request :url_encoded # passed first, only affects request parameters.
  #     faraday.request :json # 2nd, only affects request body
  #     faraday.response :json, content_type: /\bjson$/
  #     faraday.adapter Faraday.default_adapter
  # end
  def initialize(token, conn = nil)
    @api_token = token
    @canvas_conn = conn || Faraday.new(
      url: "#{CanvasFacade::CANVAS_URL}/api/v1",
      headers: auth_header
    )
  end

  def self.from_user(user)
    token = user.canvas_credentials&.token
    raise CanvasAPIError, 'Cannot find Canvas token for user' if token.nil?

    new(token)
  end

  # rubocop:disable Layout/LineLength
  # Depaginate a Canvas API response
  # call as: CanvasFacade.depaginate_response(response)
  # See https://canvas.instructure.com/doc/api/file.pagination
  # Example Header response:
  # link: <https://bcourses.berkeley.edu/api/v1/courses?page=1&per_page=10>; rel="current",<https://bcourses.berkeley.edu/api/v1/courses?page=2&per_page=10>; rel="next",<https://bcourses.berkeley.edu/api/v1/courses?page=1&per_page=10>; rel="first",<https://bcourses.berkeley.edu/api/v1/courses?page=11&per_page=10>; rel="last"
  # rubocop:enable Layout/LineLength

  HEADER_LINK_PARTS = /<(?<url>.*)>;\s+rel="(?<rel>.*)"/
  # TODO: This really needs tests
  # Because this is an instance method, it's a little awkward to use:
  # facade = CanvasFacade.new(token)
  # all_courses = facade.depaginate_response(facade.get_all_courses)
  def depaginate_response(response)
    return response unless response.success?

    links = response.headers['Link']
    return JSON.parse(response.body) unless links

    links = links.split(',').map(&:strip).filter_map do |link|
      match = link.match(HEADER_LINK_PARTS)
      { url: match[:url], rel: match[:rel] } if match
    end

    # Canvas provides a 'next' page as long as there is more to query
    next_page = links.find { |page| page[:rel] == 'next' }
    return JSON.parse(response.body) if next_page.nil?

    # NOTE: Do not log the full :url as it contains an auth token (from canvas)
    JSON.parse(response.body) + depaginate_response(@canvas_conn.get(next_page[:url], headers: auth_header))
  end

  ##
  # Gets all courses for the authorized user.
  #
  # @return [Array<Hash>] list of the Course (hashes) the user has access to.
  def get_all_courses
    depaginate_response(@canvas_conn.get('courses', {
      per_page: 100,
      'include[]': 'term'
    }))
  end

  ##
  # Get all enrollments for a course.
  #
  # https://ucberkeleysandbox.instructure.com/doc/api/courses.html#method.courses.users
  # @param  [Course] A Course object.
  # @param  [String|Array<String>] role the role to filter users by (optional).
  # @return [Array<Hash>] list of the Enrollment (hashes) in the course.
  def get_all_course_users(course, role = nil)
    # sigh, manually construct query string until we tweak Faraday middleware
    # to include :url_encoded, then use `'enrollment_type[]' : list_or_string`
    query_string = 'per_page=100'
    query_string += "&enrollment_type[]=#{role}" if role.is_a?(String) && role.present?

    if role.is_a?(Array) && role.present? # rubocop:disable Style/IfUnlessModifier
      query_string += role.map { |r| "&enrollment_type[]=#{r}" }.join
    end

    depaginate_response(@canvas_conn.get("courses/#{course.canvas_id}/users?#{query_string}"))
  end

  ##
  # Get all courses for which the user is an instructor.
  # Makes 2 API calls to Canvas, one for `teacher` and one for `ta`.
  #
  # @return [Faraday::Response] list of the courses the user is an instructor for.
  def get_instructor_courses
    teacher_courses = @canvas_conn.get('courses', {
      enrollment_type: 'teacher',
      per_page: 100,
      'include[]': 'term'
    })
    ta_courses = @canvas_conn.get('courses', {
      enrollment_type: 'ta',
      per_page: 100,
      'include[]': 'term'
    })
    teacher_courses + ta_courses
  end

  ##
  # Gets a specified course that the authorized user has access to.
  #
  # @param  [Integer] courseId the course id to look up.
  # @return [Faraday::Response] information about the requested course.
  def get_course(courseId)
    @canvas_conn.get("courses/#{courseId}")
  end

  ##
  # Gets assignments for a course (single page).
  #
  # @param  [String] course_id the Canvas course id to fetch assignments for.
  # @return [Faraday::Response] single page of assignments in the course.
  def get_assignments(course_id)
    @canvas_conn.get("courses/#{course_id}/assignments", {
      'include[]' => 'all_dates',
      'per_page' => 100
    })
  end

  ##
  # Gets all Canvas assignments for a course (paginated).
  #
  # @param  [String] course_id the Canvas course id to fetch assignments for.
  # @return [Array<Lmss::Canvas::Assignment>] list of assignments in the course.
  def get_all_assignments(course_id)
    assignments = depaginate_response(get_assignments(course_id))

    # Process assignments to extract base dates
    assignments.map do |assignment_data|
      # Unpack base date from all_dates array
      if assignment_data['all_dates']
        base_date = assignment_data['all_dates'].find { |date| date['base'] == true }
        assignment_data['base_date'] = base_date
      end
      # Return as Lmss::Canvas::Assignment object
      Lmss::Canvas::Assignment.new(assignment_data)
    end
  end

  ##
  # Gets a specified assignment from a course.
  #
  # @param  [Integer] courseId     the course to fetch the assignment from.
  # @param  [Integer] assignmentId the id of the assignment to fetch.
  # @return [Faraday::Response] information about the requested assignment.
  def get_assignment(courseId, assignmentId)
    @canvas_conn.get("courses/#{courseId}/assignments/#{assignmentId}")
  end

  ##
  # Gets a list of the assignment overrides for a specified assignment.
  #
  # @param   [Integer]    courseId     the course to fetch the overrides from.
  # @param   [Integer]    assignmentId the assignment to fetch the overrides from.
  # @return  [Faraday::Response] all of the overrides for the specified assignment.
  def get_assignment_overrides(courseId, assignmentId)
    @canvas_conn.get("courses/#{courseId}/assignments/#{assignmentId}/overrides")
  end

  ##
  # Creates a new assignment override.
  #
  # @param   [Integer]    courseId     the id of the course to create the override for.
  # @param   [Integer]    assignmentId the id of the assignment to create the override for.
  # @param   [Enumerable] studentIds   the student ids to provision the override to.
  # @param   [String]     title        the title of the new override.
  # @param   [String]     dueDate      the new due date for the override.
  # @param   [String]     unlockDate   the date the override should unlock the assignment.
  # @param   [String]     lockDate     the date the override should lock the assignment.
  # @return  [Faraday::Response] information about the new override.
  # TODO: Rename this to create_assignment_extenstion. Title should be optional.
  def create_assignment_override(courseId, assignmentId, studentIds, title, dueDate, unlockDate, lockDate)
    @canvas_conn.post("courses/#{courseId}/assignments/#{assignmentId}/overrides", {
      assignment_override: {
        student_ids: studentIds,
        title: title,
        due_at: dueDate,
        unlock_at: unlockDate,
        lock_at: lockDate
      }
    })
  end

  ##
  # Updates an existing assignment override.
  #
  # @param   [Integer]    courseId     the id of the course to update the override for.
  # @param   [Integer]    assignmentId the id of the assignment to update the override for.
  # @param   [Enumerable] studentIds   the updated student ids to provision the override to.
  # @param   [String]     title        the updated title of the override.
  # @param   [String]     dueDate      the updated due date for the override.
  # @param   [String]     unlockDate   the updated date the override should unlock the assignment.
  # @param   [String]     lockDate     the updated date the override should lock the assignment.
  # @return  [Faraday::Response] information about the updated override.
  def update_assignment_override(courseId, assignmentId, overrideId, studentIds, title, dueDate, unlockDate, lockDate)
    @canvas_conn.put("courses/#{courseId}/assignments/#{assignmentId}/overrides/#{overrideId}", {
      student_ids: studentIds,
      title: title,
      due_at: dueDate,
      unlock_at: unlockDate,
      lock_at: lockDate
    })
  end

  ##
  # Deletes an assignment override.
  #
  # @param  [Integer] courseId the id of the course where the override to delete is provisioned.
  # @param  [Integer] assignmentId the assignment for which the override to delete is provisioned.
  # @param  [Integer] overrideId the id of the override to delete.
  # @return [Faraday::Response] information about the deleted override.
  def delete_assignment_override(courseId, assignmentId, overrideId)
    @canvas_conn.delete("courses/#{courseId}/assignments/#{assignmentId}/overrides/#{overrideId}")
  end

  ##
  # Provisions a new extension to a user.
  #
  # @param   [Integer] courseId the course to provision the extension in.
  # @param   [Integer] studentId the student to provisoin the extension for.
  # @param   [Integer] assignmentId the assignment the extension should be provisioned for.
  # @param   [String]  newDueDate the date the assignment should be due.
  # @return  [Lmss::Canvas::Override] the override that acts as the extension.
  # @raises  [FailedPipelineError] if the creation response body could not be parsed.
  # @raises  [NotFoundError]       if the user has an existing override that cannot be located.
  def provision_extension(course_id, student_id, assignment_id, new_due_date)
    # get existing_overrides for an assignment
    student_override = get_existing_student_override(course_id, student_id, assignment_id)
    if !student_override.nil?
      delete_assignment_override(course_id, assignment_id, student_override.id)
    end

    # create new override
    override_title = "#{student_id} extended to #{new_due_date}"
    create_response = create_assignment_override(
      course_id, assignment_id, [ student_id ], override_title, new_due_date, get_current_formatted_time, new_due_date
    )

    decoded_response = parse_create_response(create_response)
    if create_response.status != 400 || override_has_errors?(decoded_response)
      return Lmss::Canvas::Override.new(decoded_response)
    end

    curr_override = fetch_existing_override(course_id, student_id, assignment_id)
    handle_response = handle_override_logic(
      course_id, curr_override, student_id, assignment_id, override_title,
      new_due_date
    )
    Lmss::Canvas::Override.new(parse_create_response(handle_response))
  end

  private

  ##
  # Gets the existing override for a student.
  #
  # @param  [Integer] courseId the courseId to check for an existing override.
  # @param  [Integer] studentId the student to check for an existing override for.
  # @param  [Integer] assignmentId the assignmnet to check for an existing override for.
  # @return [OpenStruct|nil] the override if it is found or nil if not.
  # @throws [FailedPipelineError] if the existing overrides response body could not be parsed.
  def get_existing_student_override(course_id, student_id, assignment_id)
    begin
      all_assignment_overrides = JSON.parse(
        get_assignment_overrides(course_id, assignment_id).body,
        object_class: OpenStruct
      )
    rescue JSON::ParserError
      raise FailedPipelineError.new(
        'Update Student Extension',
        'Get Existing Student Override',
        'Parse Canvas Response'
      )
    end

    all_assignment_overrides.each do |override|
      return override if override&.student_ids&.map(&:to_i)&.include?(student_id.to_i)
    end
    nil
  end

  ##
  # Gets the current time as formatted for Canvas's version of iso8601.
  #
  # @return [String] the current time that Canvas likes.
  def get_current_formatted_time
    currDateTimeUnformatted = DateTime.now.utc.iso8601
    # This is some weird format of iso8601 standard that Canvas likes... Don't ask me.
    "#{/[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}/.match(currDateTimeUnformatted)[0]}Z"
  end

  ##
  # Removes a student from an existing override.
  #
  # @param   [Integer]    courseId the courseId to remove the student from the override of.
  # @param   [OpenStruct] override the existing override to remove the student from.
  # @param   [Integer]    studentId the id of the student to remove from the override.
  # @return  [Faraday::Response] the new override if successful.
  # @raises  [FailedPipelineError] if the student could not be removed from the override.
  def remove_student_from_override(courseId, override, studentId)
    override.student_ids.delete(studentId)
    res = update_assignment_override(
      courseId,
      override.assignment_id,
      override.id,
      override.student_ids,
      override.title,
      override.due_at,
      override.unlock_at,
      override.lock_at
    )
    decodedBody = JSON.parse(res.body, object_class: OpenStruct)
    if decodedBody&.student_ids&.include?(studentId)
      raise FailedPipelineError.new(
        'Update Student Extension',
        'Remove Student from Existing Override',
        'Could not remove student'
      )
    end
    res
  end

  ##
  # Parses the response from creating an assignment override.
  #
  # @param  [Faraday::Response] response the response to parse.
  # @return [OpenStruct] the parsed response.
  # @raises [FailedPipelineError] if the response body could not be parsed.
  def parse_create_response(response)
    JSON.parse(response.body, object_class: OpenStruct)
  rescue JSON::ParserError
    raise FailedPipelineError.new('Update Student Extension', 'Parse Creation Response')
  end

  ##
  # Checks if the override has errors.
  #
  # @param  [OpenStruct] decoded_response the decoded response to check for errors.
  # @return [Boolean] true if the override has errors, false otherwise.
  def override_has_errors?(decoded_response)
    decoded_response&.errors&.assignment_override_students&.any? { |error| error&.type != 'taken' }
  end

  ##
  # Fetches the existing override for a student.
  #
  # @param  [Integer] courseId the courseId to fetch the override for.
  # @param  [Integer] studentId the studentId to fetch the override for.
  # @param  [Integer] assignmentId the assignmentId to fetch the override for.
  # @return [OpenStruct] the existing override.
  # @raises [NotFoundError] if the override could not be found.
  def fetch_existing_override(courseId, studentId, assignmentId)
    curr_override = get_existing_student_override(courseId, studentId, assignmentId)
    raise NotFoundError, 'could not find student\'s override' if curr_override.nil?

    curr_override
  end

  ##
  # Handles the logic for updating or creating an override.
  #
  # @param  [Integer] courseId the courseId to handle the override logic for.
  # @param  [OpenStruct] curr_override the current override to handle the logic for.
  # @param  [Integer] studentId the studentId to handle the override logic for.
  # @param  [Integer] assignmentId the assignmentId to handle the override logic for.
  # @param  [String] overrideTitle the title of the override.
  # @param  [String] newDueDate the new due date for the override.
  # @return [Faraday::Response] the response from updating or creating the override.
  def handle_override_logic(courseId, curr_override, studentId, assignmentId, overrideTitle, newDueDate)
    if curr_override.student_ids.length == 1
      update_assignment_override(
        courseId, assignmentId, curr_override.id, curr_override.student_ids, overrideTitle, newDueDate,
        get_current_formatted_time, newDueDate
      )
    else
      remove_student_from_override(courseId, curr_override, studentId)
      create_assignment_override(
        courseId, assignmentId, [ studentId ], overrideTitle, newDueDate, get_current_formatted_time, newDueDate
      )
    end
  end
end
