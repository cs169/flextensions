Feature: Navigation
  As a user
  I want to be able to navigate between pages
  So that I can access different parts of the application

  @skip @javascript
  Scenario: Navigate from Home to Login page
    Given I am on the "Home page"
    When I click "Login"
    Then I should be on the "bCourses login page"

  @skip @javascript
  Scenario: Navigate from Home to Offerings page when logged in
    Given I am logged in as a user
    And I am on the "Home page"
    When I click "Offerings"
    Then I should be on the "Offerings page"

  @skip @javascript
  Scenario: Navigate to Home page from Offerings page
    Given I am logged in as a user
    And I am on the "Offerings page"
    When I click "Home"
    Then I should be on the "Home page"

  @skip @javascript
  Scenario: Navbar elements visibility when logged in
    Given I am logged in as a user
    And I am on the "Home page"
    Then I should see "Home" in the navbar
    And I should see "Offerings" in the navbar
    And I should see "Logout" in the navbar
    And I should see my username on the navbar

  @skip @javascript
  Scenario: Navbar elements visibility when not logged in
    Given I am not logged in as a user
    And I am on the "Home page"
    Then I should see "Home" in the navbar
    And I should see "Login with bCourses" in the navbar
    And I should not see "Offerings" in the navbar
    And I should not see "Logout" in the navbar

  Scenario: Admin user sees admin tools in navbar dropdown
    Given a course exists
    And I am logged in as an admin
    And I am on the "Courses page"
    Then I should see "Admin Tools" in the navbar dropdown
    And I should see "Dashboards" in the navbar dropdown
    And I should see "Background Jobs" in the navbar dropdown

  Scenario: Non-admin user does not see admin tools in navbar dropdown
    Given a course exists
    And I am logged in as a teacher
    And I am on the "Courses page"
    Then I should not see "Admin Tools" in the navbar dropdown
    And I should not see "Dashboards" in the navbar dropdown
    And I should not see "Background Jobs" in the navbar dropdown
