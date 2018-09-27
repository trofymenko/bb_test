####################################
#          PREREQUISITES           #
####################################

Given /^login page of web application is opened$/ do
  LoginPage.open
end

When /^I put next signup data and apply on login page$/ do |data_table|
  LoginPage.on { signup_as data_table.rows_hash }
end

####################################
#              CHECKS              #
####################################

Then /^I should see the following (email|password) error message on login page$/ do |field, text|
  LoginPage.on { expect(error_message(field)).to eq text }
end
