Given /^I am a visitor$/ do
end

Given /^I am viewing (.*)$/ do |page|
  visits path_to(page)
end

Then /^I should see a link to "(.+)"$/ do |link|
  response.body.should have_tag('a', link)
end

Then /^I should see a form$/ do
  response.body.should have_tag('form')
end

Then /^I should go to (.*)$/ do |page|
  request.url.should == url_to(page)
end