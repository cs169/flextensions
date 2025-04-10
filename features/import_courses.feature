@skip
Feature: Import Courses
  As a user
  I want to import courses from Canvas
  So that I can manage them in the application

  Background:
    Given a user exists with canvas_uid "12345" and canvas_token "valid_token"
    And the following courses are available from Canvas:
      | id  | name                 | created_at          | enrollment_type |
      | 101 | CS101 - Intro to CS  | 2025-01-01T00:00:00 | teacher         |
      | 102 | CS102 - Data Science | 2025-02-01T00:00:00 | student         |
      | 103 | CS103 - Algorithms   | 2025-03-01T00:00:00 | ta              |
      | 104 | CS104 - AI           | 2025-04-01T00:00:00 | student         |

  @skip
  Scenario: Successfully import selected courses
    Given I am logged in as the user with canvas_uid "12345"
    When I visit the new courses page
    And I select the course "CS101 - Intro to CS"
    And I click "Import Selected Courses"
    Then I should see "Selected courses have been imported successfully."
    And the user should be associated with the course "CS101 - Intro to CS"

  @skip
  Scenario: Access the new courses page without logging in
    When I visit the new courses page
    Then I should be redirected to the login page
    And I should see "Please log in to access this page."

  @skip
  Scenario: Try to import courses without selecting any
    Given I am logged in as the user with canvas_uid "12345"
    When I visit the new courses page
    And I click "Import Selected Courses"
    Then I should see "Selected courses have been imported successfully."
    And the user should not be associated with any courses

  @skip
  Scenario: Teacher and student courses are listed separately
    Given I am logged in as the user with canvas_uid "12345"
    When I visit the new courses page
    Then I should see "CS101 - Intro to CS" in the teacher courses list
    And I should see "CS103 - Algorithms" in the teacher courses list
    And I should see "CS102 - Data Science" in the student courses list
    And I should see "CS104 - AI" in the student courses list

  @skip
  Scenario: Course lists should not have duplicates
    Given I am logged in as the user with canvas_uid "12345"
    When I visit the new courses page
    Then the teacher courses list should not have duplicates
    And the student courses list should not have duplicates

  @skip
  Scenario: Users can only import classes they are instructors in
    Given I am logged in as the user with canvas_uid "12345"
    When I visit the new courses page
    And I select the course "CS101 - Intro to CS"
    And I select the course "CS103 - Algorithms"
    And I select the course "CS102 - Data Science"
    And I click "Import Selected Courses"
    Then I should see "Selected courses have been imported successfully."
    And the user should be associated with the course "CS101 - Intro to CS"
    And the user should be associated with the course "CS103 - Algorithms"
    And the user should not be associated with the course "CS102 - Data Science"