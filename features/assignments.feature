Feature: Course Assignments

	Background:
		Given a course exists

	Scenario: Student doesn't see disabled assignment
		Given I'm logged in as a student
		When I go to the Request Extension page
		Then I should not see "Homework 1"

	Scenario: Student sees only enabled assignments
		Given I'm logged in as a teacher
		When I go to the Course page
		And I enable "Homework 2"
		Then I log in as a student
		And I go to the Course page
		Then I should not see "Homework 1"
		Then I should see "Homework 2"