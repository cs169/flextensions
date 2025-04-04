@skip
Feature: View Course Page

  @skip
  Scenario: Display assignments list on course page
    Given I visit "/courses/1"
    Then I should see a list of assignments
      # For example, an assignment like "Homework 1" should be visible in the assignments table

  @skip
  Scenario: Display course settings with active general tab
    Given I visit "/courses/1/edit"
    Then I should see a button with class "nav-link active" containing "General"
    And I should see a checkbox input with id "course-enable"