Feature: Send Email
As a user
I get emails when I take actions
	Before do
	  ActionMailer::Base.deliveries = []
	end

	# @javascript
	# Scenario: Registration
	# 	Given I am on the homepage
	# 	And I register as new user
	# 	Then I receive a welcome email

	# @javascript
	# Scenario: Challenge other user
	# 	Given there is at least one challenge in database
	# 	And I am logged in
	# 	And I am on the page with all the challenges
	# 	And I challenge other user
	# 	Then I should receive a challenge confirmation email
	# 	And the acceptor should receive a challenge request email
	@javascript
	Scenario: User I challenged uploads proof
		Given I challenged other user
		And he accepted the challenge
		And he uploads proof
		Then I get a proof upload email