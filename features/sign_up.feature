Feature: Sign Up
  @bvt
  Scenario Outline: sign up with empty email or password
    Given login page of web application is opened
    When I put next signup data and apply on login page
      | login    | <email>    |
      | password | <password> |
    Then I should see the following <field> error message on login page
      """
      <alert>
      """
    Examples:
      | email                | password                | field    | alert                                     |
      |                      | FACTORY_USER[:password] | email    | Don't forget to enter your email address! |
      | FACTORY_USER[:email] |                         | password | Please fill out password.                 |
      |                      |                         | email    | Don't forget to enter your email address! |

  @p1
  Scenario Outline: sign up with invalid data
    Given login page of web application is opened
    When I put next signup data and apply on login page
      | login    | <email>    |
      | password | <password> |
    Then I should see the following <field> error message on login page
      """
      <alert>
      """
    Examples:
      | email                | password | field    | alert                                                    |
      | user                 | pass1234 | email    | Hmm, looks like that email is not in the correct format. |
      | user@xyz             | pass1234 | email    | Hmm, looks like that email is not in the correct format. |
      | user@x,za            | pass1234 | email    | Hmm, looks like that email is not in the correct format. |
      | user@x@y.za          | pass1234 | email    | Hmm, looks like that email is not in the correct format. |
      | user@x#y.za          | pass1234 | email    | Hmm, looks like that email is not in the correct format. |
      | FACTORY_USER[:email] | pass1    | password | Password must contain at least 6 characters.             |