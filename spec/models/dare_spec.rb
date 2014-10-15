require 'rails_helper'

describe Dare do
  let(:dare) { build_stubbed(:dare) }
  let(:user) { build_stubbed(:user) }

  it "has a valid factory" do
    expect(dare).to be_valid
  end

  it "has a challenge, acceptor and challenger" do
    expect(dare.challenge_id).to_not be_nil
    expect(dare.challenger_id).to_not be_nil
    expect(dare.acceptor_id).to_not be_nil
  end

  it "has status 'pending' when created by a user to challenge a different user" do
    new_dare = create(:dare, challenger_id: 1, acceptor_id: 2)
    expect(new_dare.status).to eq 'Pending'
  end

  it "has status 'Accepted' when acceptor and challenger are the same user" do
    new_dare = create(:dare, challenger_id: 1, acceptor_id:1)
    expect(new_dare.status).to eq 'Accepted'
  end

  it "is initiated with an empty array for proofs" do
    new_dare = create(:dare)
    expect(new_dare.utube_link).to eq []
  end

  it "has status 'Failed' if status was 'Accepted', 7 days passed since it's creation and no proof has been uploaded" do
    new_dare = create(:dare, challenger_id: 1, acceptor_id: 2, status: 'Accepted', start_date: 8.day.ago, utube_link: [])
    new_dare.no_proof_fail?
    expect(new_dare.status).to eq 'Failed'
  end

  it "has status 'success' if it was 'Accepted', a proof has been uploaded, more than 12 days passed and has not been accepted/rejected by the challenger" do
    new_dare = create(:dare, status: 'Accepted', utube_link: [1], start_date: 13.days.ago )
    new_dare.success_unvalidated?
    expect(new_dare.status).to eq 'Success'
  end

  it "is set put to the vote if after 7 days it has a proof, challenger rejected proof and status is not 'voting'" do
    new_dare = create(:dare, status: 'Accepted', start_date: 7.days.ago, proof_status: 'Rejected', utube_link: [1] )
    new_dare.up_for_voting?
    expect(new_dare.status).to eq 'Voting'
  end

  it "has status 'Success' and voting_status 'Success' if after voting finished, there are more or the same nr of votes for than against" do
    new_dare = create(:dare, status: 'Voting', voting_start_date: 6.days.ago, utube_link: [1])
    new_dare.voting_finished?
    expect(new_dare.status).to eq 'Success'
    expect(new_dare.voting_status).to eq 'Success'
  end

  it "has status 'Failed' and voting_status 'Failed' if after voting finished, there are more votes agains than for" do
    new_dare = create(:dare, status: 'Voting', voting_start_date: 5.days.ago, utube_link: [1])
    new_vote = create(:vote, dare_id: new_dare.id, vote_for: false)
    new_dare.voting_finished?
    expect(new_dare.status).to eq 'Failed'
    expect(new_dare.voting_status).to eq 'Failed'
  end


end
