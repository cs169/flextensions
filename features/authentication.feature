Feature: User Authentication and Access Control
  As a user
  I want to be able to log in and out
  So that I can access my courses

  @javascript @skip
  Scenario: Failed login with invalid credentials
    Given I am on the "bCourses login page"
    When I authorize bCourses with invalid credentials
    And I should be on the "bCourses login page"

  @javascript @skip
  Scenario: Successful login with valid credentials
    Given I am on the "bCourses login page"
    When I authorize bCourses with valid credentials
    And I should be on the "Courses page"

  @javascript @skip
  Scenario: Successfully access the Courses page with valid credentials
    Given I am logged in as a user
    Then I should see my name on the navbar

  @javascript
  Scenario: Attempt to access the Courses page with invalid credentials
    Given I am not logged in as a user
    When I navigate to any page other than the "Home page"
    Then I should be redirected to the "Home page"

  @javascript @skip
  Scenario: Unable to access the Courses page after logging out
    Given I am logged in as a user
    When I navigate to the "Courses page"
    And I log out
    And I navigate to the "Courses page"
    Then I should be redirected to the "Home page"
