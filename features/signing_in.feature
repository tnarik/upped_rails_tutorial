Feature: Signing in
  
  Scenario: Unsuccessful signin
    Given a user visits the signin page
    When he submits invalid signin information
    Then he should see an error message
  
  Scenario: Successful signin
    Given the user has an account
      And the user has verified it
      And a user visits the signin page
     When the user submits valid signin information
     Then he should see his profile page
      And he should see a signout link