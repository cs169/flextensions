Feature: Navigation
  As a user
  I want to be able to navigate between pages
  So that I can access different parts of the application

  Scenario: Navigate from Home to Login page
    Given I am on the "Home page"
    When I click "Login with bCourses"
    Then I should be on the "bCourses login page"

  Scenario: Navigate from Home to Offerings page when logged in
    Given I am logged in as a user
    And I am on the "Home page"
    When I click "Offerings"
    Then I should be on the "Offerings page"

  Scenario: Navigate to Home page from Offerings page
    Given I am logged in as a user
    And I am on the "Offerings page"
    When I click "Home"
    Then I should be on the "Home page"

  Scenario: Navbar elements visibility when logged in
    Given I am logged in as a user
    And I am on the "Home page"
    Then I should see "Home" in the navbar
    And I should see "Offerings" in the navbar
    And I should see "Logout" in the navbar
    And I should see my username on the navbar

  Scenario: Navbar elements visibility when not logged in
    Given I am not logged in as a user
    And I am on the "Home page"
    Then I should see "Home" in the navbar
    And I should see "Login with bCourses" in the navbar
    And I should not see "Offerings" in the navbar
    And I should not see "Logout" in the navbar 