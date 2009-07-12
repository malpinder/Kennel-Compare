Feature: Account management
  As a user
  I want an account management panel
  So I can change my details and settings

Scenario: An owner visits his account page
  Given I am a pet owner
  When I go to my account page
  Then I should see "Your settings"
  And I should see a link to "Edit"

Scenario Outline: An owner wishes to change their password
  Given I am a pet owner
  When I go to my account page
  And I follow "Edit"
  And I fill in "Password" with "<my new password>"
  And I fill in "Confirm Password" with "<my new password>"
  And I press "Update"
  Then I should go to <a page>
  And I should see a <type of> message

Examples:
  |my new password|a page         |type of|
  |validpassword  |my account page|notice |
  |wrong          |my edit page   |error  |