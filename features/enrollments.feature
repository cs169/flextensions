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