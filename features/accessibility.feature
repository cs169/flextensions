Feature: Accessibility Testing
  As a user with disabilities
  I want the application to be accessible in all theme modes
  So that I can use it effectively regardless of my visual preferences

  # Basic accessibility tests
  @a11y @javascript
  Scenario: Home page should be accessible
    Given I am on the "Home page"
    Then the page should be axe clean

  @a11y @javascript
  Scenario: Courses page should be accessible
    Given I am logged in as a user
    And I am on the "Courses page"
    Then the page should be axe clean

  # Theme-specific accessibility tests
  @a11y @theme @javascript
  Scenario: Home page should be accessible in light mode
    Given I am on the "Home page"
    And I am using the "light" theme
    Then the page should be axe clean

  @a11y @theme @javascript
  Scenario: Home page should be accessible in dark mode
    Given I am on the "Home page"
    And I am using the "dark" theme
    Then the page should be axe clean
    
  @a11y @theme @javascript
  Scenario: Courses page should be accessible in light mode
    Given I am logged in as a user
    And I am on the "Courses page"
    And I am using the "light" theme
    Then the page should be axe clean
    
  @a11y @theme @javascript
  Scenario: Courses page should be accessible in dark mode
    Given I am logged in as a user
    And I am on the "Courses page"
    And I am using the "dark" theme
    Then the page should be axe clean
