Given /^I am a visitor$/ do
end
Given /^I am not logged in$/ do
  visit path_to('the main page')
  click_link('Log Out')
end

Given /^I am a pet owner$/ do
  post owners_path, :owner => {:first_name => 'valid', :surname => 'test', :password => 'testpass', :password_confirmation => 'testpass', :email => 'test@test.com'}
  post session_path, :account => {:first_name => 'valid', :surname => 'test', :password => 'testpass', :type => 'owner'}
end

Given /^I am a kennel manager$/ do
  post kennels_path, :kennel => {:kennel_name => 'valid', :address => 'test', :postcode => 'A1 1AA', :password => 'testpass', :password_confirmation => 'testpass', :email => 'test@test.com'}
  post session_path, :account => {:kennel_name => 'valid', :postcode => 'A1 1AA', :password => 'testpass', :type => 'kennel'}
end

Given /^I am viewing (.*)$/ do |page|
  visit path_to(page)
end

Given /^I have a owner account$/ do
  post owners_path, :owner => {:first_name => 'valid', :surname => 'test', :password => 'testpass', :password_confirmation => 'testpass', :email => 'test@test.com'}
end

Given /^I have a kennel account$/ do
  post kennels_path, :kennel => {:kennel_name => 'valid', :address => 'test', :postcode => 'A1 1AA', :password => 'testpass', :password_confirmation => 'testpass', :email => 'test@test.com'}
end
Given /^there is a kennel account$/ do
  post kennels_path, :kennel => {:kennel_name => 'valid', :address => 'test', :postcode => 'A1 1AA', :password => 'testpass', :password_confirmation => 'testpass', :email => 'test@test.com'}
end

When /^I log in with (valid|invalid) owner details$/ do |type|
  visit path_to("the login page")
  within "div#owner_form" do |scope|
    scope.fill_in("First Name", :with => type)
    scope.fill_in("Password", :with => "testpass")
    scope.fill_in("Surname", :with => "test")
    scope.click_button("Login")
  end
end

When /^I log in with (valid|invalid) kennel details$/ do |type|
  visit path_to("the login page")
  within "div#kennel_form" do |scope|
    scope.fill_in("Kennel Name", :with => type)
    scope.fill_in("Postcode", :with => 'A1 1AA')
    scope.fill_in("Password", :with => "testpass")
    scope.click_button("Login")
  end
end
