@d8 @api
Feature: Search
  Search is the most important part of a site!

  Scenario: Search with no test content produces no results
    Given I am on the homepage
    And I fill in "Search" with "noodle-G-splat!"
    When I press the "Search" button
    Then I should see "Your search yielded no results"

  @javascript @to-do
#    Won't find article!
  Scenario: Creating a new article and running cron successfully
    When I am viewing an "article" content with the title "noodle-G-splat!"
    Then I should see the heading "noodle-G-splat!"
    Then I run cron
    And I wait for AJAX to finish
    #Search with test content produces result
    Given I am on the homepage
    And I fill in "Search" with "noodle-G-splat!"
    And I press the "Search" button
#    And I wait for AJAX to finish
    And I should not see "Your search yielded no results"
    And I should see "noodle-G-splat!"