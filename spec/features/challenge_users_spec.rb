require "rails_helper"

feature "Challenge users" do
  let!(:challenge) { create(:challenge)}
  let(:user) { create(:user)}
  
  context "as a registered user" do
    before :each do
      log_in(user)
    end
    scenario "challenges himself" do

      expect(current_path).to eq root_path
      expect(page).to have_content challenge.name

      click_button 'Accept'
      
      expect(page).to have_content 'You accepted the challenge!'
      expect(user.accepted_dares.count).to eq 1
    end

    scenario 'challenges other user' do
      expect(current_path).to eq root_path

      click_button 'Challenge others'

      expect(current_path).to eq new_challenge_dare_path(challenge_id: challenge.id)
      expect(page).to have_content 'Challenge with a bet!'
    end
  end
end