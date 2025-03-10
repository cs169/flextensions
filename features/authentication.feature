
Feature: User Login Flow

    Scenario 1: Successful login with valid credentials
    Given I am on the "bCourses login page"
    When I authorize bCourses with valid credentials
    Then I should be on the "Offerings page"


    Scenario 2: Failed login with invalid credentials
    Given I am on the "bCourses login page"
    When I authorize bCourses with invalid credentials
    Then I should see an error message "login failure"
    And I should be on the "bCourses login page"



Feature: Offerings Page Access Control

    Scenario 1: Successfully access the offerings page with valid credentials
    Given I am logged in as a user
    And I on the "Offerings page"
    Then I should see my username on the navbar


    Scenario 2: Attempt to access the offerings page with invalid credentials
    Given I am not logged in as a user
    When I navigate to any page other than the "Home page"
    Then I should be redirected to the "bCourses login page"


    Scenario 3: Successfully access the offerings page after logging out
    Given I am logged in as a user
    When I navigate to the "Offerings page"
    And I log out
    And I navigate to the "Offerings page"
    Then I should be redirected to the "bCourses login page"



