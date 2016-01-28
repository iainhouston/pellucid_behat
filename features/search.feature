@d8 @api
Feature: Search
  Search is the most important part of a site!

  Scenario: Search with no test content produces no results
    Given I am on "search/node"
    And the response status code should be 200
    And I fill in "edit-keys" with "noodle"
    When I press "edit-submit"
    Then I should see "Your search yielded no results"

  @to-do
  Scenario: Search with test content produces result
  I wonder why this isn't working?
    When I am viewing an "article" content with the title "noodle"
    Then I should see the heading "noodle"
    Then I run cron
    And I am on "search/node"
    And I fill in "edit-keys" with "noodle"
    And I press "edit-submit"
    Then the response status code should be 200
    And I should not see "Your search yielded no results"
    And I should see "noodle" 