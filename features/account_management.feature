Feature: Account management
  As a user
  I want an account management panel
  So I can change my details and settings

Scenario Outline: An user visits his account page
  Given I am <a user>
  When I go to my <user> account page
  Then I should see a link to "Edit your settings and details"

Examples:
  |a user           |user   |
  |a pet owner      |owner  |
  |a kennel manager |kennel |

Scenario Outline: A user wishes to change their password
  Given I am <a user>
  When I go to my <user> account page
  And I follow "Edit"
  And I fill in "Password" with "<my new password>"
  And I fill in "Confirm Password" with "<my new password>"
  And I press "Update"
  Then I should go to <a page>
  And I should see a <type of> message

Examples:
  |a user           |user   |my new password|a page                |type of|
  |a pet owner      |owner  |validpassword  |my owner account page |notice |
  |a pet owner      |owner  |wrong          |my owner edit page    |error  |
  |a kennel manager |kennel |validpassword  |my kennel account page|notice |
  |a kennel manager |kennel |wrong          |my kennel edit page   |error  |