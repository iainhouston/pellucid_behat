@d8 @api
Feature: Bradford Abbas Content Management for all users
  Test that the website is sending mails for regular system purposes
  i.e. not as a result of the Pellucid functionality

  @email
  Scenario: Send an email when a user resets her password
    Given users:
      | name    | mail           | status |
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
    And I press the "Send message" button
    # "You cannot send more than 5 messages in 1 hour. Try again later."
    Then  I should not see the error message containing "Try again later."
    And I should see the success message containing "Your message has been sent"
    And an email should be sent

