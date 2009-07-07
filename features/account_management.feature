Feature: Account management
  As a user
  I want an account management panel
  So I can change my details and settings

Scenario: A visitor tries to access an account page
  Given I have a owner account
  And I am not logged in
  When I go to the first pet owner account page
  Then I should see a warning message
  And I should not see "Your account settings"