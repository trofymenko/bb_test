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
  Scenario: forgotten password reset
    Given login page of web application is opened
    And I reset password for u97fq9usi@mg.strongqa.com email on login page
    Then I should see the following successful message on login page
      """
      Password reset, email was sent to
      """

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

  @p2
  Scenario: sign up with short password
    Given login page of web application is opened
    When I put next signup data and apply on login page
      | login    | FACTORY_USER[:email] |
      | password | pass1                |
    Then I should see the following password error message on login page
      """
      Password must contain at least 6 characters.
      """