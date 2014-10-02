require 'rails_helper'

RSpec.describe Dare, :type => :model do
  it "has a challenge, acceptor and challenger" do
    dare = Dare.new(challenge_id: 1, acceptor_id: 1, challenger_id: 3)
    expect(dare.acceptor_id).to eq 1
    expect(dare.challenge_id).to eq 1
    expect(dare.challenger_id).to eq 3
  end

  it "has status 'pending' when created by a user to challenge a different user" do
    # user1 = User.new(username: 'Josh', id: 1)
    # user1 = User.new(username: 'Tom', id: 2)
    dare = Dare.create(challenger_id: 2, acceptor_id: 2)
    expect(dare.status).to eq 'Pending'
  end
end
