@api
Feature: Bradford Abbas Content Management for Officers
  When I log into the website
  As an Officer
  I should be able to create, edit, or delete Meetings

  Scenario: An Officer should be able create Meetings
    Given I am logged in as a user with the "Officer" role
    When I go to "node/add/meeting"
    Then I should not see "Access denied"
    And I should see the link "Edit"

  Scenario: An Officer should be able to see existing Agendas
    Given I am logged in as a user with the "Officer" role
    When I go to "node/29"
    Then I should see "Agenda for Ordinary Parish Council Meeting on Tuesday, 5 January 2016"

  Scenario: Create users
    Given users:
    | name     | mail            | status |
    | Joe User | joe@example.com | 1      |
    And I am logged in as an Officer
    When I visit "admin/people"
    Then I should see the link "Joe User"
