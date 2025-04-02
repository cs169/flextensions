Feature: Course Offerings Management
  As a Canvas user
  I want to see my courses
  So that I can access and manage them

  @skip
  Scenario: View all courses as a teacher
    Given I am logged in as a user with "teacher" role
    And I am on the "Offerings page"
    Then I should see my courses where I am a teacher
    And I should see my courses where I am a student

  @skip
  Scenario: View all courses as a student
    Given I am logged in as a user with "student" role
    And I am on the "Offerings page"
    Then I should see my courses where I am a student
    And I should not see courses where I am not enrolled

  @skip
  Scenario: No courses available
    Given I am logged in as a user with no courses
    And I am on the "Offerings page"
    Then I should see a message "No courses found"

  @skip
  Scenario: Failed to fetch courses due to API error
    Given I am logged in as a user with an invalid token
    And I am on the "Offerings page"
    Then I should see an error message "Failed to fetch courses" 