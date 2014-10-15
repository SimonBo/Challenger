require "rails_helper"

feature "Challenge users" do
  let!(:challenge) { create(:challenge)}
  context "as a user" do
    scenario "challenges himself" do
      user = create(:user)
      sign_in(user)

      expect(current_path).to eq root_path
      expect(page).to have_content 'Signed in successfully.'
      expect(page).to have_content challenge.name


      # click_button 'Accept'
      # expect(user.accepted_dares.count).to eq 1

      expect {
        click_button 'Accept'
        user.reload
      }.to change(user.accepted_dares, :count).by(1)
      expect(page).to have_content 'You accepted the challenge!'
    end
  end
end