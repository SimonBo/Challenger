Feature: Send Email
As a user
I get emails when I take actions
	Before do
	  ActionMailer::Base.deliveries = []
	end

# 	@javascript
# 	Scenario: Registration
# 		Given I am on the homepage
# 		And I register as new user
# 		Then I receive a welcome email

# 	@javascript
# 	Scenario: Challenge other user
# 		Given there is at least one challenge in database
# 		And I am logged in
# 		And I am on the page with all the challenges
# 		And I challenge other user
# 		Then I should receive a challenge confirmation email
# 		And the acceptor should receive a challenge request email

# 	@javascript
# 	Scenario: User I challenged uploads proof
# 		Given I challenged other user
# 		And he accepted the challenge
# 		And he uploads proof
# 		Then I get a proof upload email

# 	@javascript
# 	Scenario: I accept proof
# 		Given I challenged other user
# 		And he accepted the challenge
# 		And he uploads proof
# 		And I accept proof
# 		Then he gets proof acceptance email
# 		And I get end of challenge email

# 	@javascript
# 	Scenario: I reject proof
# 		Given I challenged other user
# 		And he accepted the challenge
# 		And he uploads proof
# 		And I reject proof
# 		Then he gets proof rejection email
# 		And I get voting start email

# 	Scenario: The proof I uploaded wasn't validated by the challenger and the time has expired
# 		Given I upload proof
# 		And 7 days pass
# 		And the challenger doesn't accept or reject my proof
# 		Then the challenge is put to the vote
# 		And I get voting start email
# 		And the challenger gets voting start email 

# 	Scenario: The voting on the challenge I created has finished and I won
# 		Given the voting has started
# 		And the acceptor wins the voting
# 		Then the challenger gets voting end email
# 		And the acceptor gets voting end email

# 	@javascript
# 	Scenario: User accepts challenge
# 		Given I challenged other user
# 		And he accepted the challenge
# 		Then I get challenge acceptance email
# 		And he gets challenge acceptance email

# 	@javascript
# 	Scenario: User rejects challenge
# 		Given I challenged other user
# 		And he rejected the challenge
# 		Then I get challenge rejection email
# 		And he gets challenge rejection email

	# @javascript
	# Scenario: User didn't upload any proof and the time's up
	# 	Given I challenged other user
	# 	And he accepted the challenge
	# 	And he didn't upload any proof
	# 	And the time to complete the challenge has ended
	# 	Then I get no proof fail email
	# 	And he gets no proof fail email
  
      # @javascript
      # Scenario: Self challenge
      #   Given I challenge myself
      #   And I upload  proof
      #   And I click "Finished uploading proof"
      #   Then other users can vote whether my proof is valid
      #   And I get voting result email after 5 days

      Scenario: I invite a new user
        Given there is at least one challenge in database
        And I am logged in
        And I am on the page with all the challenges
        And I click on 'Invite your friend'
        And I provide my friend's email
        Then he gets an invitation email
        And he can click a button that takes him to the website
        And he can accept challenge and register as new user
        And I get invitation response email when he responds

