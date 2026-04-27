Feature: Course Enrollments

	Background:
		Given a course exists

	Scenario: display Enrollments
		Given I'm logged in as a teacher
		When I go to the Course Enrollments page
		Then I should see "User 1"
		And I should see "User 2"
		And I should see "User 3"
		And I should see "User 4"
		And I should see "User 5"

	@javascript
	Scenario: Instructor toggles "Approved Extended?" on for a student
		Given I'm logged in as a teacher
		When I go to the Course Enrollments page
		And I toggle "Approved Extended?" for "User 3"
		Then the enrollment for "User 3" should allow extended requests

	@javascript
	Scenario: Instructor toggles "Approved Extended?" off for a student
		Given I'm logged in as a teacher
		And the enrollment for "User 3" allows extended requests
		When I go to the Course Enrollments page
		And I toggle "Approved Extended?" for "User 3"
		Then the enrollment for "User 3" should disallow extended requests
   
  @javascript
	Scenario: Clicking a student name on Enrollments navigates to filtered requests
		Given a request exists for student "User 3"
		And I'm logged in as a teacher
		When I go to the Course Enrollments page
		And I click the name link for student "User 3"
		Then I should be on the "Requests page" with param show_all=true
		And the requests table search should be filtered

	Scenario: Instructor sees the Sync Enrollments button
		Given I'm logged in as a teacher
		When I go to the Course Enrollments page
		Then I should see a "Sync Enrollments" button

	@javascript
	Scenario: Clicking Sync Enrollments disables the button and shows a spinner
		Given I'm logged in as a teacher
		When I go to the Course Enrollments page
		And I click the "Sync Enrollments" button
		Then the "Sync Enrollments" button should be disabled
		And I should see a loading spinner
