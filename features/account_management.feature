Feature: Account management
  As a user
  I want an account management panel
  So I can change my details and settings

Scenario: An owner visits his account page
  Given I am a pet owner
  When I go to the first pet owner account page
  Then I should see "Your settings"
  And I should see a link to "Edit"