Feature: Course Form Settings

	Background:
		Given a course exists

	Scenario: display form settings
		Given I'm logged in as a teacher
		When I go to the Form Settings page
		Then I should see "Form Settings"

	Scenario: Changing Reason custom description
		Given I'm logged in as a teacher
		When I go to the Form Settings page
		And I fill in "form_setting_reason_desc" with "Updated reason description"
		And I press "Update"
		Then I log in as a student 
		And I go to the Request Extension page
		Then I should see "Updated reason description"

	Scenario: Changing Additional Documentation description and display setting
		Given I'm logged in as a teacher
		When I go to the Form Settings page
		And I fill in "form_setting_documentation_desc" with "Added documentation details"
		And I select "Required" from "form_setting_documentation_disp"
		And I press "Update"
		Then I log in as a student
		And I go to the Request Extension page
		Then I should see "Added documentation details"
		And I should see "Additional Documentation*"

	Scenario: Changing Custom Question 1 title, description, and display setting
		Given I'm logged in as a teacher
		When I go to the Form Settings page
		And I fill in "form_setting_custom_q1" with "Custom Question 1 Title"
		And I fill in "form_setting_custom_q1_desc" with "Details for custom question 1"
		And I select "Optional" from "form_setting_custom_q1_disp"
		And I press "Update"
		Then I log in as a student
		And I go to the Request Extension page
		Then I should see "Custom Question 1 Title"
		And I should see "Details for custom question 1"

	Scenario: Changing Custom Question 2 title, description, and display setting
		Given I'm logged in as a teacher
		When I go to the Form Settings page
		And I fill in "form_setting_custom_q2" with "Custom Question 2 Title"
		And I fill in "form_setting_custom_q2_desc" with "Details for custom question 2"
		And I select "Hidden" from "form_setting_custom_q2_disp"
		And I press "Update"
		Then I log in as a student
		And I go to the Request Extension page
		Then I should not see "Custom Question 2 Title"
