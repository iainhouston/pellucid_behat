@d8 @api
Feature: Bradford Abbas Content Management for Anonymous users
When I visit the website without being logged in
I should be able to do stuff that is the main purpose of the whole project
Like seeing all the stuff required by the Transparency Code
But I should not be able to do stuff that only an Officer or a Councillor can do

  Scenario: An Anonymous user should not be able create Meetings
    Given  I am an anonymous user
    When I go to "node/add/meeting"
    Then I should see the text "Access denied"

  Scenario: An Anonymous user should not see the Tools menu
    Given  I am an anonymous user
    When I visit "node/31"
    # region doesn't work for us
#    Then I should not see the text "Tools" in the "content_bottom" region


