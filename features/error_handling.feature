Feature: Error Handling
  As a user
  I want to see helpful error messages
  So that I can understand when something goes wrong

  Scenario: Authentication error with missing code
    Given I am on the "bCourses login page"
    When I try to authenticate with a missing code
    Then I should see an error message "Authentication failed"
    And I should be on the "Home page"

  Scenario: Authentication error with Canvas API
    Given I am on the "bCourses login page"
    When I try to authenticate with an error response from Canvas
    Then I should see an error message "Authentication failed"
    And I should be on the "Home page"

  Scenario: Error fetching courses from Canvas
    Given I am logged in as a user
    And the Canvas API is unavailable
    When I navigate to the "Offerings page"
    Then I should see an error message "Failed to fetch courses from Canvas"

  Scenario: Access unauthorized page
    Given I am not logged in as a user
    When I directly access the "Offerings page"
    Then I should see an error message "Please log in to access this page"
    And I should be redirected to the "Home page" 