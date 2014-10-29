require 'rails_helper'
require 'rake'

describe 'dares namespace rake task' do
  let!(:challenge) { create(:challenge)}
  let!(:user_challenger) { create(:user)}
  let!(:user_acceptor) { create(:user)}
  let!(:dare) { create(:dare, start_date: 2.days.ago, challenge_id: challenge.id, acceptor_id: user_acceptor.id, challenger_id: user_challenger.id, status: 'Accepted')}
  
  # before { Challenger::Application.load_tasks }

  # it { expect { Rake::Task['dares:process'].invoke }.not_to raise_exception }

  describe 'dares:process' do
    # before do
    #   load "tasks/dares.rake"
    #   Rake::Task.define_task(:environment)
    # end

    # it "should returns properly start" do
    #   Rake::Task["dares:process"].invoke
    # end
    # before { Challenger::Application.load_tasks }

    it "should fail a dare that has no proof and run out of time" do
      dare.start_date = 7.days.ago
      # expect{Rake::Task['dares:process'].invoke}.to change{ dare.status }.from('Pending').to('Failed')
      dare.process
      # Rake::Task['dares:process'].invoke 
      expect(dare.status).to eq 'Failed'
    end

    it "should shouldn't fail a dare if proof was uploaded but not validated" do
      dare.start_date = 7.days.ago
      dare.utube_link = ['something']
      dare.process
      expect(dare.status).not_to eq 'Failed'
    end

    it "should start voting if the uploaded proof was not validated and the dare expired" do
      dare.start_date = 8.days.ago
      dare.utube_link = ['something']
      dare.process
      expect(dare.status).to eq 'Voting'
    end

    it "should make dare successful if a proof was uploaded but not validated by challenger within 2 days since the end of challenge" do
      dare.start_date = 9.days.ago
      dare.utube_link = ['something']
      dare.process
      expect(dare.status).to eq 'Success' 
    end

    it "should end voting if the time for voting has finished" do
      dare.voting_start_date = 5.days.ago
      dare.process
      expect(dare.status).to eq 'Success'
    end

    it "should mark dare as failed if there was more against votes after the voting ended" do
      dare.voting_start_date = 5.days.ago
      3.times do |n|
        create(:vote, dare_id: dare.id, vote_for: false, user_id: rand(100))
      end
      create(:vote, dare_id: dare.id)
      dare.process
      expect(dare.status).to eq 'Failed'
    end

    it "should send email to acceptor if his challenge expires tomorrow" do
      ActionMailer::Base.deliveries = []
      dare.start_date = 6.days.ago
      dare.process
      expect(ActionMailer::Base.deliveries.last.subject).to eq "Your challenge expires tomorrow! Let #{user_challenger.username} know what you've done."
    end
  end
end
