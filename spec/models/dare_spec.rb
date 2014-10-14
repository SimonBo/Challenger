require 'rails_helper'

describe Dare do
  let(:dare) { build_stubbed(:dare) }

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

  it "has status 'Failed' if status was 'Accepted', 7 days passed since it's creation and no proof has been uploaded" do
    new_dare = create(:dare, challenger_id: 1, acceptor_id: 2, status: 'Accepted', start_date: 8.day.ago, utube_link: [])
    new_dare.no_proof_fail?
    expect(new_dare.status).to eq 'Failed'
  end

end
