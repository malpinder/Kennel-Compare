Feature: Registration system
  As a user
  I want to have an account
  So that the site can be tailored to me

Scenario: A visitor starts the registration process
  Given I am a visitor
  And I am viewing the main page
  When I follow "Sign Up"
  Then I should go to the "choose new account type" page

Scenario Outline: A visitor wishes to register an account
  Given I am a visitor
  And I am viewing the "choose new account type" page
  When I choose "<account type>"
  And I press "Continue"
  Then I should go to the new <account> page

Examples:
  |account type  |account|
  |account_type_owner     |owner  |
  |account_type_kennel        |kennel |