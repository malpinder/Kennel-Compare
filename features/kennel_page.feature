Feature: Kennel account pages
  As a user
  The kennel page needs to be clear and simple
  As it holds the most important information on the site

Scenario Outline: Someone visits a kennel home page
  Given there is a kennel account
  And I am a <user>
  When I go to the first kennel account page
  Then I should see "Rating"
  And I <might> see a link to "Rate these kennels"
  And I should see "Latest Reviews"
  And I should see a link to "See all reviews"
  And I <might> see a link to "Review these kennels"

Examples:
  |user           |might      |
  |visitor        |should not |
  |pet owner      |should     |
  |kennel manager |should not |