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
		Then the enrollment for "User 3" should have allow_extended_requests enabled

	@javascript
	Scenario: Instructor toggles "Approved Extended?" off for a student
		Given I'm logged in as a teacher
		And the enrollment for "User 3" has allow_extended_requests enabled
		When I go to the Course Enrollments page
		And I toggle "Approved Extended?" for "User 3"
		Then the enrollment for "User 3" should have allow_extended_requests disabled