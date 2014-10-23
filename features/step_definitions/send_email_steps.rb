Given(/^I am on the homepage$/) do
  visit root_path
end

Given(/^I register as new user$/) do
  click_button 'Sign up'
  email = Faker::Internet.email
  fill_in 'Email', :with => email
  username = Faker::Internet.user_name
  fill_in 'Username', :with => username
  fill_in 'user_password', :with => 'useruser'
  fill_in 'confirmation', :with => 'useruser'
  click_button 'sign_up_submit'
end

Then(/^I receive a welcome email$/) do
  user = User.last
  expect(ActionMailer::Base.deliveries.count).to eq 1
end

Given(/^I am logged in$/) do
  visit root_path
  @user = FactoryGirl.create(:user)
  click_button 'Sign in'
  fill_in 'Login', :with => @user.email
  fill_in 'Password', :with => @user.password
  click_button 'Log in'
end

Given(/^I am on the page with all the challenges$/) do
  visit challenges_path
end

Given(/^there is at least one challenge in database$/) do
  FactoryGirl.create(:challenge)
end

Given(/^I challenge other user$/) do
  click_button 'Challenge others'
  @test_user = FactoryGirl.create(:user)
  click_link 'Find by name/email'
  fill_in 'query', with: @test_user.username
  click_button 'Search'
  click_button 'Challenge!'
end

Then(/^I should receive a challenge confirmation email$/) do
  expect(ActionMailer::Base.deliveries.first.to).to eq [@user.email]
end

Then(/^the acceptor should receive a challenge request email$/) do
  expect(ActionMailer::Base.deliveries.last.to).to eq [@test_user.email]
end

Given(/^I challenged other user$/) do
  @challenge = FactoryGirl.create(:challenge)
  @challenger = FactoryGirl.create(:user)
  @acceptor = FactoryGirl.create(:user)
  @dare = FactoryGirl.create(:dare, challenger_id: @challenger.id, acceptor_id: @acceptor.id, challenge_id: @challenge.id)
  expect(ActionMailer::Base.deliveries.count).to eq 2
end

Given(/^he accepted the challenge$/) do
  visit root_path
  click_button 'Sign in'
  fill_in 'Login', :with => @acceptor.email
  fill_in 'Password', :with => @acceptor.password
  click_button 'Log in'

  click_button 'Accept'
end

Given(/^he uploads proof$/) do
  visit challenge_dare_path(@challenge, @dare)
  fill_in 'dare_vid_link', with: "https://youtu.be/cD4TAgdS_Xw"
  click_button "Upload Youtube Video"
  save_and_open_screenshot
end

Then(/^I get a proof upload email$/) do
  expect(page).to have_content 'Added proof'
  expect(ActionMailer::Base.deliveries.count).to eq 3
  # expect(ActionMailer::Base.deliveries.last.to).to eq [@challenger.email]
end

