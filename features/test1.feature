@api
Feature: Content Management
  When I log into the website
  As an administrator
  I should be able to create, edit, and delete page content

  Scenario: An administrative user should be able create page content
    Given I am logged in as a user with the "administrator" role
    When I go to "node/add/page"
    Then I should not see "Access denied"