require "rails_helper"

feature "Challenge users" do
  let!(:challenge) { create(:challenge)}
  let(:user) { create(:user)}
  
  context "as a registered user" do
    before :each do
      log_in(user)
    end
    scenario "challenges himself", broken: true  do

      expect(current_path).to eq challenges_path
      expect(page).to have_content challenge.name

      click_button 'Accept'
      
      expect(page).to have_content 'You accepted the challenge!'
      expect(user.accepted_dares.count).to eq 1
    end

    scenario 'challenges other user', js: true do
      expect(current_path).to eq challenges_path

      click_button 'Challenge others'

      expect(page).to have_content 'Who do you want to challenge to'
      expect(current_path).to eq new_challenge_dare_path(challenge_id: challenge.id)
      
    end
  end
end