# features/accessibility.feature
Feature: Accessibility Testing
  As a user with disabilities
  I want the application to be accessible
  So that I can use it effectively


  @a11y
  Scenario: Home page should be accessible
    Given I am on the "Home page"
    Then the page should be axe clean

  @a11y
  Scenario: Login page should be accessible
    Given I am on the "bCourses login page"
    Then the page should be axe clean
  @a11y
  Scenario: Offerings page should be accessible when logged in
    And I am on the "Offerings page"
    Then the page should be axe clean
