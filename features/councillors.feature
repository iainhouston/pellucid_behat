@d8 @api
Feature: Bradford Abbas Content Management for Councillors
When I log into the website
As a Councillor
I should be able to do stuff that neither an Anonymous nor an Authenticated user can do
Buut I should not be able to do what an Officer can do

  Scenario: Send an email when an Councillor resets her password
    Given I am logged in as a Councillor
  When I visit "contact"
  And I fill in "edit-subject-0-value" with "It's a subject"
    And I fill in "edit-message-0-value" with "It's a message"
    And I press the "Send message" button
    # "You cannot send more than 5 messages in 1 hour. Try again later."
    Then  I should not see the error message containing "Try again later."
    And I should see the success message containing "Your message has been sent"
    And an email should be sent

