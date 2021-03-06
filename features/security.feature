Feature: Security
  As a user
  I want my account to be protected from unauthorised users
  So they cannot change or snoop on my stuff

Scenario: A visitor accesses an account page
  Given I have a owner account
  And I am not logged in
  When I go to the first pet owner account page
  Then I should not see a link to "Edit"

Scenario: A user tries to access someone else's edit page
  Given I am a kennel manager
  When I go to the first pet owner edit page
  Then I should see a warning message
  And I should not see "Your account settings"