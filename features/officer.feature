@api
Feature: Bradford Abbas Content Management for Officers
  When I log into the website
  As an Officer
I should be able to create, edit, and delete Meetings

  Scenario: An Officer should be able create Meetings
    Given I am logged in as a user with the "Officer" role
    When I go to "node/add/meeting"
    Then I should not see "Access denied"

  Scenario: An Officer should be able to see existing Agendas
    Given I am logged in as a user with the "Officer" role
    When I go to "node/29"
    Then I should see "Agenda for Ordinary Parish Council Meeting on Tuesday, 5 January 2016"

