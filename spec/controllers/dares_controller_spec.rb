require 'rails_helper'

describe DaresController do
  let(:challenger) { create(:user) }
  let(:acceptor) { create(:user) }
  let(:challenge) { create(:challenge) }
  let(:dare) { create(:dare, acceptor_id: acceptor) }
  let(:user) { create(:user) }


  # before { controller.stub(:authenticate_user!).and_return true }
  describe 'Guest access to dares' do

    describe 'GET #show' do
      it "redirects to root" do
        sign_in nil
        get :show, id: dare.id, challenge_id: challenge.id
        expect(response).to require_login
      end
    end

    # describe 'GET #new' do
    #   it "redirects to root" do
    #     get :new, id: dare, challenge_id: challenge.id
    #     expect(response).to require_login
    #   end
    # end
    
    # # describe 'GET #edit' do
    # #   it "redirects to root" do
    # #     get :edit, id: dare, challenge_id: challenge.id
    # #     expect(response).to require_login
    # #   end
    # # end

    # describe 'POST #create' do
    #   it "redirects to root" do
    #     post :create, id: dare, challenge_id: challenge.id
    #     expect(response).to require_login
    #   end
    # end

    # describe 'PATCH #update' do
    #   it "redirects to root" do
    #     patch :update, id: dare, challenge_id: challenge.id
    #     expect(response).to require_login
    #   end
    # end

    # describe 'DELETE #destroy' do
    #   it "redirects to root" do
    #     delete :destroy, id: dare, challenge_id: challenge.id
    #     expect(response).to require_login
      # end
    # end
  end
end