Feature: User Authentication and Access Control

  @skip @javascript
  Scenario: Successful login with valid credentials
    Given I am on the "bCourses login page"
    When I authorize bCourses with valid credentials
    Then I should be on the "Courses page"

  @skip @javascript
  Scenario: Failed login with invalid credentials
    Given I am on the "bCourses login page"
    When I authorize bCourses with invalid credentials
    Then I should see an error message "login failure"
    And I should be on the "bCourses login page"

  @skip @javascript
  Scenario: Successfully access the Courses page with valid credentials
    Given I am logged in as a user
    And I am on the "Courses page"
    Then I should see my username on the navbar

  @skip
  Scenario: Attempt to access the Courses page with invalid credentials
    Given I am not logged in as a user
    When I navigate to any page other than the "Home page"
    Then I should be redirected to the "bCourses login page"

  @skip @javascript
  Scenario: Successfully access the Courses page after logging out
    Given I am logged in as a user
    When I navigate to the "Courses page"
    And I log out
    And I navigate to the "Courses page"
    Then I should be redirected to the "bCourses login page"



