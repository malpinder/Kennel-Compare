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
  |account type       |account|
  |account_type_owner |owner  |
  |account_type_kennel|kennel |

Scenario Outline: A visitor wishes to register as a pet owner
  Given I am a visitor
  And I am viewing the new owner page
  When I fill in "First Name" with "<first name>"
  And I fill in "Surname" with "<surname>"
  And I fill in "Password" with "<password>"
  And I fill in "Confirm Password" with "<confirmation>"
  And I fill in "Email" with "<email>"
  And I press "Register"
  Then I <might> go to the owner account page
  And I <also might> see an error message

Examples:
  |first name |surname    |password|confirmation|email          |might      |also might|
  |Charlie    |Barkin     |password|password    |email@email.com|should     |should not|
  |Carface    |Carruthers |password|wrong       |notvalid       |should not |should|
  |Annemarie  |           |password|password    |               |should not |should|
