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
	Scenario: Clicking a student name on Enrollments navigates to filtered requests
		Given I'm logged in as a teacher
		When I go to the Course Enrollments page
		And I click the name link for student "User 3"
		Then I should be on the "Requests page" with param show_all=true
		And the requests table search should be filtered