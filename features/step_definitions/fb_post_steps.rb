Given(/^I register with facebook$/) do
  click_button 'Facebook Connect'
end

Then(/^I can accept that the app will access my facebook profile$/) do
  save_and_open_screenshot
  expect(page).to have_content 'Challenger will receive the following info: your public profile, friend list and email address.'
  click_on 'Okay'
end

Then(/^I can give the app permission to post in my name$/) do
  expect(page).to have_content 'Challenger would like to post to Facebook for you.'
end

Then(/^if I accept$/) do
  click_on 'Okay'
end

Then(/^the app posts on my wall "(.*?)"$/) do |arg1|
  visit 'https://www.facebook.com/'
  expect(page).to have_content "Today, I joined the Challenger. It's uber cool. Check it out at simon-challenger.herokuapp.com"
end

