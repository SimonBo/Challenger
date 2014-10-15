require "rails_helper"

describe User do
  it { should validate_presence_of :username }
  it { should ensure_length_of(:username).is_at_least(2).is_at_most(50) }
  it { should validate_uniqueness_of :username }

  let(:user) { build_stubbed(:user) }
  let(:new_user) { build_stubbed(:user) }

  it "does not allow voting in the dare where the user is the challenger" do
  	dare = create(:dare, challenger_id: user.id, acceptor_id: new_user.id)
  	vote = create(:vote, dare_id: dare.id)
  	vote.user_id = user.id
  	expect(vote).to_not be_valid
  end

   it "does not allow voting in the dare where the user is the acceptor" do
  	dare = create(:dare, challenger_id: new_user.id, acceptor_id: user.id)
  	vote = create(:vote, dare_id: dare.id)
  	vote.user_id = user.id
  	expect(vote).to_not be_valid
  end


end