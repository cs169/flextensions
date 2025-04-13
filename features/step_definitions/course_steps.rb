=begin
Database Setup Overview (from "a course exists" step)

TABLE: courses
------------------------------------------------
| ID | course_name   | canvas_id | course_code |
------------------------------------------------
| 1  | Physics 110A  | Phys110A  | PHYS110A    |
|    |               |           |             |
|    |               |           |             |
|    |               |           |             |
|    |               |           |             |
------------------------------------------------

TABLE: lmss
---------------------------------------
| ID | lms_name      | use_auth_token |
---------------------------------------
| 1  | Canvas OAUTH  | true           |
---------------------------------------

TABLE: course_to_lmss
--------------------------------------------------------------
| ID | lms_id | course_id | external_course_id               |
--------------------------------------------------------------
| 1  | 1      | 1         | ext-001                          |
--------------------------------------------------------------

TABLE: assignments (5 records)
-------------------------------------------------------------------------------------------------
| ID | name   | external_assignment_id | course_to_lms_id | due_date         | late_due_date    
|    |        |                        |                  | (approx.)        | (approx.)        
|------------------------------------------------------------------------------------------------|
| 1  | HW 1   | ext-assignment-1       | 1                | Time.now + 7d    | Time.now + 10d   
| 2  | HW 2   | ext-assignment-2       | 1                | Time.now + 8d    | Time.now + 11d   
| 3  | HW 3   | ext-assignment-3       | 1                | Time.now + 9d    | Time.now + 12d   
| 4  | HW 4   | ext-assignment-4       | 1                | Time.now + 10d   | Time.now + 13d   
| 5  | HW 5   | ext-assignment-5       | 1                | Time.now + 11d   | Time.now + 14d   
|------------------------------------------------------------------------------------------------|
| extensions_enabled: false, enabled: false (for all assignments)
-------------------------------------------------------------------------------------------------

TABLE: users (5 records)
---------------------------------------------------------------------------------------------
| ID | name   | email                  | canvas_uid      | canvas_token      | student_id |
---------------------------------------------------------------------------------------------
| 1  | User1  | user1@berkeley.edu     | canvas_uid_1    | canvas_token_1    | (nil)      |
| 2  | User2  | user2@berkeley.edu     | canvas_uid_2    | canvas_token_2    | (nil)      |
| 3  | User3  | user3@berkeley.edu     | canvas_uid_3    | canvas_token_3    | (nil)      |
| 4  | User4  | user4@berkeley.edu     | canvas_uid_4    | canvas_token_4    | (nil)      |
| 5  | User5  | user5@berkeley.edu     | canvas_uid_5    | canvas_token_5    | (nil)      |
---------------------------------------------------------------------------------------------

TABLE: user_to_courses (5 records)
------------------------------------------------
| ID | user_id | course_id | role     |
------------------------------------------------
| 1  | 1       | 1         | teacher  |
| 2  | 2       | 1         | ta       |
| 3  | 3       | 1         | student  |
| 4  | 4       | 1         | student  |
| 5  | 5       | 1         | student  |
------------------------------------------------

Note: 
- The "ID" fields are auto-generated primary keys.
- Timestamps (created_at/updated_at) are not shown here.
- Date/time fields such as due_date and late_due_date are calculated at runtime.
- Additional columns for each table not explicitly listed in this overview are present per your schema definition.
=end

Given(/^a course exists$/) do
	# Create a course with all required columns
	@course = Course.create!(
	  course_name: "Physics 110A",
	  canvas_id: "Phys110A",
	  course_code: "PHYS110A",
	)
	
	# Create an LMS record as required by CourseToLms
	lms = Lms.create!(
	  lms_name: "Canvas OAUTH",
	  use_auth_token: true
	)
	
	# Create a CourseToLms record with the newly created LMS
	course_to_lms = CourseToLms.create!(
	  lms: lms,
	  course: @course,
	  external_course_id: "ext-001"
	)
	
	# Create 5 assignments for the course using the course_to_lms record
	5.times do |i|
	  Assignment.create!(
		name: "HW #{i+1}",
		course_to_lms_id: course_to_lms.id,
		external_assignment_id: "ext-assignment-#{i+1}",
		due_date: Time.now + (7 + i).days,
		late_due_date: Time.now + (10 + i).days,
		extensions_enabled: false,
		enabled: false
	  )
	end
	
	# Create 5 users and assign them roles (one teacher, one ta, three students)
	roles = %w[teacher ta student student student]
	roles.each_with_index do |role, i|
	  user = User.create!(
		name: "User#{i+1}",
		email: "user#{i+1}@berkeley.edu",
		canvas_uid: "canvas_uid_#{i+1}",
		canvas_token: "canvas_token_#{i+1}"
	  )
	  UserToCourse.create!(
		user: user,
		course: @course,
		role: role
	  )
	end
  end

  Given(/^(?:I am|I'm) logged in as a teacher$/) do
	page.set_rack_session(user_id: 1, username: 'User1')
  end

  Given(/^(?:I am|I'm) logged in as a TA$/) do
	page.set_rack_session(user_id: 2, username: 'User2')
  end
  
  Given(/^(?:I am|I'm) logged in as a student$/) do
	page.set_rack_session(user_id: 3, username: 'User3')
  end

