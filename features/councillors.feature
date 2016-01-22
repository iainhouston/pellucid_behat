@d8 @api
Feature: Bradford Abbas Content Management for Councillors
When I log into the website
As a Councillor
I should be able to receive a password reset email 

@email
Scenario: Send an email when a user resets her password
  Given users:
    | name    | mail            | status |
    | Jo User | jo@example.com | 1      |
  When I visit "user/password"
  And I fill in "name" with "jo@example.com" 
  When I press the "Submit" button
  Then an email should be sent to "jo@example.com"

@email
Scenario: Send an email when an Officer resets her password
  Given I am logged in as an Officer
  When I visit "contact"
  And I fill in "edit-subject-0-value" with "It's a subject" 
  And I fill in "edit-message-0-value" with "It's a message" 
  When I press the "Send message" button
  Then an email should be sent

