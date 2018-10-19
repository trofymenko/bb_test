####################################
#          PREREQUISITES           #
####################################

Given /^login page of web application is opened$/ do
  LoginPage.open
end

When /^I put next signup data and apply on login page$/ do |data_table|
  LoginPage.on { signup_as data_table.rows_hash }
end

When /^I reset password for (.*?) email on login page$/ do |email|
  LoginPage.on { reset_password email }
end

####################################
#              CHECKS              #
####################################

Then /^I should see the following (email|password) error message on login page$/ do |field, text|
  LoginPage.on { expect(error_message(field)).to eq text }
end

Then /^I should see the following successful message on login page$/ do |text|
  LoginPage.on { expect(message).to include text }
end
