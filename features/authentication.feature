Feature: User Authentication and Access Control
  As a user
  I want to be able to log in and out
  So that I can access my courses

  Scenario: Successful login with valid credentials
    Given I am on the "bCourses login page"
    When I authorize bCourses with valid credentials
    Then I should be on the "Courses page"

  Scenario: Failed login with invalid credentials
    Given I am on the "bCourses login page"
    When I authorize bCourses with invalid credentials
    Then I should see an error message "Authentication failed"
    And I should be on the "bCourses login page"

<<<<<<< HEAD
  Scenario: Successfully access the offerings page with valid credentials
=======
  @skip
  Scenario: Successfully access the Courses page with valid credentials
>>>>>>> 996db56c078398d24147a724abe6826238d3e538
    Given I am logged in as a user
    And I am on the "Courses page"
    Then I should see my username on the navbar

<<<<<<< HEAD
  Scenario: Attempt to access the offerings page with invalid credentials
=======
  @skip
  Scenario: Attempt to access the Courses page with invalid credentials
>>>>>>> 996db56c078398d24147a724abe6826238d3e538
    Given I am not logged in as a user
    When I navigate to any page other than the "Home page"
    Then I should be redirected to the "bCourses login page"

<<<<<<< HEAD
  Scenario: Successfully access the offerings page after logging out
=======
  @skip
  Scenario: Successfully access the Courses page after logging out
>>>>>>> 996db56c078398d24147a724abe6826238d3e538
    Given I am logged in as a user
    When I navigate to the "Courses page"
    And I log out
    And I navigate to the "Courses page"
    Then I should be redirected to the "bCourses login page"



