Feature: Student Notes

Background:
    Given a course exists
    And I'm logged in as a teacher
    When I go to the Course page
    And I enable "Homework 1"

Scenario: Teacher sees notes section on request detail page
    Given I'm logged in as a student
    And I go to the Course page
    And I click New for "Homework 1" in the "assignments-table"
    And I fill in "request[reason]" with "Need more time"
    And I press "Submit Request"
    Then I log in as a Teacher
    And I view the request for "Homework 1"
    Then I should see "Staff Notes for"
    And I should see "No notes yet."

Scenario: Teacher can save notes for a student
    Given I'm logged in as a student
    And I go to the Course page
    And I click New for "Homework 1" in the "assignments-table"
    And I fill in "request[reason]" with "Need more time"
    And I press "Submit Request"
    Then I log in as a Teacher
    And the student for the course has notes "Student has DSP accommodations."
    And I view the request for "Homework 1"
    Then I should see "Student has DSP accommodations."

Scenario: Student does not see staff notes on their request page
    Given I'm logged in as a student
    And I go to the Course page
    And I click New for "Homework 1" in the "assignments-table"
    And I fill in "request[reason]" with "Need more time"
    And I press "Submit Request"
    Given the student for the course has notes "Internal staff note"
    And I go to the Requests page
    And I click View for "Homework 1" in the "requests-table"
    Then I should not see "Staff Notes for"
    And I should not see "Internal staff note"
