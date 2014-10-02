require 'rails_helper'

RSpec.describe Dare, :type => :model do

  it "has a challenge, acceptor and challenger" do
    dare = Dare.new(challenge_id: 1, acceptor_id: 1, challenger_id: 3)
    expect(dare.acceptor_id).to eq 1
    expect(dare.challenge_id).to eq 1
    expect(dare.challenger_id).to eq 3
  end

  it "has status 'pending' when created by a user to challenge a different user" do

    dare = Dare.create(challenger_id: 1, acceptor_id: 2)
    expect(dare.reload.status).to eq 'Pending'
  end

  it "has status 'Failed' if status was 'Accepted', 7 days passed since it's creation and no proof has been uploaded" do
  	dare = Dare.new(challenge_id: 1, acceptor_id: 1, challenger_id: 3, status: "Accepted", created_at: DateTime.now - 8.days)
  	expect(dare.proof?).to eq false
  	expect(dare.unresolved?).to eq true
  end
end
