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

#Then /^I should see an error message$/ do
  #response.body.should have_tag('div id="errorExplantion"')
#end

#Then /^I should not see an error message$/ do
  #response.body.should_not have_tag('div id="errorExplantion"')
#end

Then /^I should go to (.*)$/ do |page|
  request.url.should == url_to(page)
end

Then /^I should not go to (.*)$/ do |page|
  request.url.should_not == url_to(page)
end