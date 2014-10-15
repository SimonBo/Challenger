require 'rails_helper'

describe Challenge, type: :model do
	it { should validate_presence_of :name }
	it { should validate_presence_of :description }
	it { should validate_uniqueness_of :name }
	it { should ensure_length_of(:name).is_at_least(5).is_at_most(100) }
	it { should ensure_length_of(:description).is_at_least(10).is_at_most(500) }
end