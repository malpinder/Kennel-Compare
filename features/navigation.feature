Feature: navigation system
  As a user of the site
  I want a navigation system
  To easily reach the pages I want to see

Scenario: A visitor wishes to access the sign up & login system.
  Given I am a visitor
  When I go to the main page
  Then I should see a link to "Sign Up"
  And I should see a link to "Log In"

Scenario: A visitor has not logged in
  Given I am a visitor
  When I go to the main page
  Then I should not see a link to "Log Out"

Scenario: A pet owner has logged in
  Given I am a pet owner
  When I go to the main page
  Then I should see who I am logged in as
  And I should see a link to "Not you?"