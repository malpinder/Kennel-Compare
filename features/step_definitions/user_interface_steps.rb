Then /^I should see a link to "(.+)"$/ do |link|
  response.body.should have_tag('a', link)
end

Then /^I should not see a link to "(.+)"$/ do |link|
  response.body.should_not have_tag('a', link)
end

Then /^I should see a form$/ do
  response.body.should have_tag('form')
end

Then /^I should see (a|an) (notice|warning|error) message$/ do |grammar, type|
  response.body.should have_tag("div.#{type}")
end

Then /^I should not see (a|an) (notice|warning|error) message$/ do |grammar, type|
   response.body.should_not have_tag("div.#{type}")
end

Then /^I should see who I am logged in as$/ do
  response.body.should contain("You are logged in as")
end

Then /^I should go to (.*)$/ do |page|
  request.url.should == url_to(page)
end

Then /^I should not go to (.*)$/ do |page|
  request.url.should_not == url_to(page)
end