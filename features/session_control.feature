Feature: Logging in & out
  As a user
  I wish to log in and out
  So that I can do stuff securely etc

Scenario: a visitor wishes to log in
  Given I am a visitor
  And I am viewing the main page
  When I follow "Log In"
  Then I should go to the login page
  And I should see a form

Scenario Outline: An user tries to log in
  Given I am viewing the login page
  And I have a <type of> account
  When I log in with <my details>
  Then I <might> go to the <type of> account page
  And I should see <a kind of> message

Examples:
  |type of  |my details             |might      |a kind of|
  |owner    |valid owner details    |should     |a notice |
  |owner    |invalid owner details  |should not |a warning|
  |kennel   |valid kennel details   |should     |a notice |
  |kennel   |invalid kennel details |should not |a warning|