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
end

Then(/^I get a proof upload email$/) do
  expect(page).to have_content 'Added proof'
  expect(ActionMailer::Base.deliveries.count).to eq 3
  expect(ActionMailer::Base.deliveries.last.to).to eq [@challenger.email]
end

Given(/^I accept proof$/) do
  visit root_path

  click_on "#{@acceptor.username}"
  click_on "Sign out"

  click_button 'Sign in'
  fill_in 'Login', :with => @challenger.email
  fill_in 'Password', :with => @challenger.password
  click_button 'Log in'

  within('#i_challenged') do
    click_on "#{@challenge.name}"
  end
  click_on 'Accept proof'
end

Then(/^he gets proof acceptance email$/) do
  expect(ActionMailer::Base.deliveries[ActionMailer::Base.deliveries.length-2].to).to eq [@acceptor.email]
end

Then(/^I get end of challenge email$/) do
  expect(ActionMailer::Base.deliveries.last.to).to eq [@challenger.email]
end

Given(/^I reject proof$/) do
  visit root_path

  click_on "#{@acceptor.username}"
  click_on "Sign out"

  click_button 'Sign in'
  fill_in 'Login', :with => @challenger.email
  fill_in 'Password', :with => @challenger.password
  click_button 'Log in'

  within('#i_challenged') do
    click_on "#{@challenge.name}"
  end
  click_on 'Reject proof'
end

Then(/^he gets proof rejection email$/) do
  expect(ActionMailer::Base.deliveries[ActionMailer::Base.deliveries.length-2].to).to eq [@acceptor.email]
  expect(ActionMailer::Base.deliveries[ActionMailer::Base.deliveries.length-2].subject).to eq "#{@challenger.username.capitalize} has rejected your proof!"
end

Then(/^I get voting start email$/) do
  expect(ActionMailer::Base.deliveries.last.to).to include (@challenger.email)
  expect(ActionMailer::Base.deliveries.last.subject).to eq "#{@dare.challenge.name} was put to the vote!"
end

Given(/^I upload proof$/) do
  @challenge = FactoryGirl.create(:challenge)
  @challenger = FactoryGirl.create(:user)
  @acceptor = FactoryGirl.create(:user)
  @dare = FactoryGirl.create(:dare, challenger_id: @challenger.id, acceptor_id: @acceptor.id, challenge_id: @challenge.id)

  @dare.utube_link = @dare.utube_link + ["cD4TAgdS_Xw"]
  @dare.save!
end

Given(/^(\d+) days pass$/) do |arg1|
  @dare.start_date = arg1.to_i.days.ago
  @dare.save!
end

Given(/^the challenger doesn't accept or reject my proof$/) do
expect(@dare.proof_status).to eq 'Unaccepted'
end

Then(/^the challenge is put to the vote$/) do
  @dare.up_for_voting?
  expect(@dare.status).to eq 'Voting'
end

Then(/^the challenger gets voting start email$/) do
  expect(ActionMailer::Base.deliveries.last.subject).to eq "#{@dare.challenge.name} was put to the vote!"
end

Given(/^the voting has started$/) do
  @challenge = FactoryGirl.create(:challenge)
  @challenger = FactoryGirl.create(:user)
  @acceptor = FactoryGirl.create(:user)
  @dare = FactoryGirl.create(:dare, challenger_id: @challenger.id, acceptor_id: @acceptor.id, challenge_id: @challenge.id)

  @dare.utube_link = @dare.utube_link + ["cD4TAgdS_Xw"]
  @dare.status = 'Voting'
  @dare.proof_status = 'Rejected'
  @dare.voting_start_date = DateTime.now
  @dare.save!
end

Given(/^the acceptor wins the voting$/) do
  3.times do |i|
    FactoryGirl.create(:vote, dare_id: @dare.id, user_id: FactoryGirl.build_stubbed(:user).id) 
  end
  FactoryGirl.create(:vote, dare_id: @dare.id, vote_for: false)
  @dare.voting_start_date = 5.days.ago
  @dare.voting_finished?

  expect(@dare.status).to eq 'Success'
end

Then(/^the challenger gets voting end email$/) do
  expect(ActionMailer::Base.deliveries[ActionMailer::Base.deliveries.length-2].to).to eq [@challenger.email]
  expect(ActionMailer::Base.deliveries.last.subject).to eq "The voting for #{@dare.challenge.name} has ended!" 
end

Then(/^the acceptor gets voting end email$/) do
  expect(ActionMailer::Base.deliveries.last.to).to include (@acceptor.email)
end

