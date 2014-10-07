require 'spec_helper'
require 'rails_helper'

describe DaresController, :type => :controller do
  describe 'PATCH update' do 
    it 'save the youtube link to dare' do
      @challenger = FactoryGirl::create(:user)
      @acceptor = FactoryGirl::create(:user)
      @challenge = FactoryGirl::create(:challenge)

      @dare = Dare.create(acceptor: @acceptor, challenge: @challenge, challenger: @challenger, status: 'Accepted')
      patch :update, {challenge_id: @challenge.id, id: @dare, dare: {vid_link: "https://www.youtube.com/watch?v=dOV9RZ5u_68"}}
      @dare.reload.utube_link.should == ["dOV9RZ5u_68"]

    end

    it 'not save the invalid link to dare' do
      @challenger = FactoryGirl::create(:user)
      @acceptor = FactoryGirl::create(:user)
      @challenge = FactoryGirl::create(:challenge)

      @dare = Dare.create(acceptor: @acceptor, challenge: @challenge, challenger: @challenger, status: 'Accepted')
      patch :update, {challenge_id: @challenge.id, id: @dare, dare: {vid_link: "https://www.google.com"}}
      @dare.reload.utube_link.should == []

    end

    it 'show msg when link not provided' do
      @challenger = FactoryGirl::create(:user)
      @acceptor = FactoryGirl::create(:user)
      @challenge = FactoryGirl::create(:challenge)

      @dare = Dare.create(acceptor: @acceptor, challenge: @challenge, challenger: @challenger, status: 'Accepted')
      patch :update, {challenge_id: @challenge.id, id: @dare, dare: {vid_link: ""}}
      @dare.reload.utube_link.should == []
      flash.should_not be_nil

    end
  end
end