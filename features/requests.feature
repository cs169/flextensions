Feature: Extension Requests

	Background:
		Given a course exists
        And I'm logged in as a teacher
        When I go to the Course page
        # Homework 1: Due Date is 1 Day from now, Late Due Date is 10 Days from now
		And I enable "Homework 1"
        # Homework 2: Due Date is 2 Day from now, Late Due Date is 20 Days from now 
		And I enable "Homework 2"
        # Homework 3: Due Date is 3 Day from now, Late Due Date is 30 Days from now
		And I enable "Homework 3"


	Scenario: Assignment auto selected when student creates a request from the course page
		Given I'm logged in as a student
		And I go to the Course page
		And I click New for "Homework 2" in the "assignments-table"
        Then I should be redirected to the "Request Extension page" with param assignment_id=2
        And the "Select Assignment" select should have "Homework 2" selected
        And I should see "Original Due Date" formatted as 2 days from now
        And I should see "Original Late Due Date" formatted as 20 days from now

    @javascript
    Scenario: Changing Assignment changes due date (JS)
		Given I'm logged in as a student
		And I go to the Request Extension page
		When I select "Homework 1" from "Select Assignment"
        Then I should see "Original Due Date" formatted as 1 days from now
        And I should see "Original Late Due Date" formatted as 10 days from now
        When I select "Homework 2" from "Select Assignment"
        Then I should see "Original Due Date" formatted as 2 days from now
        And I should see "Original Late Due Date" formatted as 20 days from now

    @javascript
    Scenario: Changing "Requested Due Date"/"Assignment" changes Number of Days
		Given I'm logged in as a student
		And I go to the Request Extension page
		When I select "Homework 1" from "Select Assignment"
        And I fill in Requested Due Date with date formatted as 5 days from now
        Then I should see "Number of Days: 4"
        When I select "Homework 2" from "Select Assignment"
        Then I should see "Number of Days: 1"



    Scenario: Student creates a request and teacher Approves
        Given I'm logged in as a student
		And I go to the Course page
		And I click New for "Homework 2" in the "assignments-table"
        And I fill in "request[reason]" with "I'm a little behind and need more time"
        And I press "Submit Request"
        Then I should see "Your extension request has been submitted."
        Then I log in as a Teacher
        And I go to the Requests page
        And I approve the request for "Homework 2"
        Then I should see "Request approved and extension created successfully in Canvas."

    Scenario: Student creates a request and teacher Deny
        Given I'm logged in as a student
		And I go to the Course page
		And I click New for "Homework 1" in the "assignments-table"
        And I fill in "request[reason]" with "I'm a little behind and need more time"
        And I press "Submit Request"
        Then I should see "Your extension request has been submitted."
        Then I log in as a Teacher
        And I go to the Requests page
        And I deny the request for "Homework 1"
        Then I should see "Request denied successfully."

	Scenario: Teacher sees Request in Requests table
		Given I'm logged in as a student
		And I go to the Course page
		And I click New for "Homework 3" in the "assignments-table"
        And I fill in "request[reason]" with "I'm a little behind and need more time"
        And I press "Submit Request"
        Then I log in as a teacher
		And I go to the Requests page
		Then I should see "Homework 3"

