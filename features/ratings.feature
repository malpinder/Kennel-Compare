Feature: Rating system for kennels
  As a user
  I want a numerical rating system for kennels
  So I can compare them easily and quickly

Scenario: A pet owner sees a newly-registered kennels
  Given there is a kennel account
  And I am a pet owner
  When I go to the first kennel account page
  Then I should see "These kennels have not been rated yet"

Scenario: A pet owner wishes to rate a kennel
  Given there is a kennel account
  And I am a pet owner
  When I go to the first kennel account page
  And I follow "Rate these kennels"
  Then I should go to the first kennel rating page
  And I should see a form

Scenario: A pet owner rates a kennel as '3'
  Given there is a kennel account
  And I am a pet owner
  And I am viewing the first kennel rating page
  When I select "3" from "Rating"
  And I press "Rate!"
  Then I should go to the first kennel account page
  And I should see "Rating: 3 out of 5"