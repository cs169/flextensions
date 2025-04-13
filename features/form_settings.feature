Feature: Course Form Settings

  Background:
    Given a course exists
    And I'm logged in as a teacher

  Scenario: display form settings
    When I go to form settings page
    Then I should see "Number of Days"