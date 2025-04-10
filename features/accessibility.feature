# features/accessibility.feature
Feature: Accessibility Testing
  As a user with disabilities
  I want the application to be accessible
  So that I can use it effectively

  @a11y @javascript @skip
  Scenario: Home page should be accessible
    Given I am on the "Home page"
    Then the page should be axe clean

  @a11y @skip @javascript
  Scenario: Login page should be accessible
    Given I am on the "bCourses login page"
    Then the page should be axe clean

  @a11y @skip @javascript
  Scenario: Courses page should be accessible
    And I am on the "Courses page"
    Then the page should be axe clean
