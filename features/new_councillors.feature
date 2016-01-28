@api
Feature: Bradford Abbas Content Management for Officers - Feature 1
When I log into the website As an Officer
I should be able to create website users (with the Councillor role)**
and fill in the custom fields required by the Transparency Code

  @javascript @email
  Scenario: An Officer can create website users and fill in the custom fields required by the Transparency Code
    Given I am logged in as an Officer
    # The toolbar across the top of the page after I log in is the "Admin menu" link
    Then I should see the link "Admin menu"
    When I click "Admin menu"
    And I wait for AJAX to finish
    # The toolbar item "People" is the "Manage user accounts, roles, and permissions." link
    And I click "Manage user accounts, roles, and permissions."
    Then I should not see "Access denied"
    And I should see the link "Add user"
    When I click "Add user"

    # This describes what the Officer sees
    Then I should see the heading "Add user"
    When I fill in "Email address" with "jo@bloggs.com"
    And I fill in "Username" with "New Councillor"
      # Any old password will do at this stage;
      # the new Councillor will be emailed instrucions to login and change their password
    And I fill in "Password" with "llkjhl-.A2"
    And I fill in "Confirm password" with "llkjhl-.A2"
    And I fill in "First and Last names" with "New Councillor"
    And I check the box "Notify user of new account"
      # And I select "Councillor" from "Roles"
    And I select "Councillor" from "Function"
    And I fill in "Telephone" with "01935 410881"
    And I fill in "Postal address" with "1 Coombe Cottages, North St., DT9 6SD"
    And I fill in "External bodies" with "Crime Commissioners Office"
    And I fill in "Notes" with "Website"
    And I see the text "Select the newsletter(s) to which you wish to subscribe"
    And I check the box "Councillors"
      # "Contact settings" should be expanded by default
    And I should see "Personal contact form"
    And I check the box "Personal contact form"
    When I press the "Create new account" button
    Then I should see the success message containing "further instructions has been emailed to the new user"
    And an email should be sent to "jo@bloggs.com"

  @javascript
  Scenario: An Officer can cancel a user account
    Given I am logged in as an Officer
    # The toolbar across the top of the page after I log in is the "Admin menu" link
    Then I should see the link "Admin menu"
    When I click "Admin menu"
    And I wait for AJAX to finish
    Then I should see the link "Manage user accounts, roles, and permissions."
    When I click "Manage user accounts, roles, and permissions."
    Then I should see "New Councillor"
    When I click "New Councillor"
    Then I see the heading "New Councillor"
    When I click "Edit"
    Then I should see the button "Cancel account"
    # The "Cancel account" link is also known as "edit-delete"
    When I press the "Cancel account" button
    Then I see the heading "Are you sure you want to cancel the account New Councillor?"
      # Use this default setting
    And the checkbox "Disable the account and keep its content." should be checked
    Then I select the radio button "Delete the account and make its content belong to the Anonymous user." with the id "edit-user-cancel-method-user-cancel-reassign"
    When I press the "Cancel account" button
    And I wait for AJAX to finish
    Then I should see the success message containing "deleted"

  @javascript
  Scenario: A deleted user should not be found on the "People" page
    Given I am logged in as an Officer
    # The "Manage" menu item in the toolbar across the top of the page after I log in is also known as the "Admin menu" link
    Then I should see the link "Admin menu"
    When I click "Admin menu"
    Then I should see the link "Manage user accounts, roles, and permissions."
    When I click "Manage user accounts, roles, and permissions."
    Then I should not see "New Councillor"

#**
# Revision from original intention:
# Currently only an Administrator can create a new user with extra website permissions so having an Officer
# create Councillor users is not possible without exposing extra User-management stuff not relevant to an Officer.
# In any case, there are no cases yet that need any special Councillor privileges on the website, so we'll
# remove the Councillor Role for now. Not to be confused with the Councillor taxonomy term used to tag Councillor
# responsibilities on the Parish Council.)

