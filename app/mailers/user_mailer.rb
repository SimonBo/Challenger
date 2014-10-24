class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def welcome_email(user)
    @user = user
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end

  def self_challenge(user, dare)
    @user = user
    @dare = dare
    mail(to: @user.email, subject: "#{@user.username.capitalize}, you challenged yourself! Congratulations!")    
  end

  def you_challenged(challenger, acceptor, dare)
    @challenger = challenger
    @acceptor = acceptor
    @dare = dare
    mail(to: @challenger.email, subject: "You challenged #{@acceptor.username.capitalize}")
  end

  def you_were_challenged(challenger, acceptor, dare)
    @challenger = challenger
    @acceptor = acceptor  
    @dare = dare
    mail(to: @acceptor.email, subject: "You've been challenged by #{@challenger.username.capitalize}")
  end

  def user_accepted_challenge(challenger, acceptor, dare)
    @challenger = challenger
    @acceptor = acceptor  
    @dare = dare
    mail(to: @challenger.email, subject: "#{@acceptor.username.capitalize} accepted your challenge!")
  end

  def you_accepted_challenge(challenger, acceptor, dare)
    @challenger = challenger
    @acceptor = acceptor  
    @dare = dare
    mail(to: @acceptor.email, subject: "You accepted #{@challenger.username.capitalize}'s challenge!")
  end

  def user_rejected_challenge(challenger, acceptor, dare)
    @challenger = challenger
    @acceptor = acceptor  
    @dare = dare
    mail(to: @challenger.email, subject: "#{@acceptor.username.capitalize} rejected your challenge!")
  end

  def you_rejected_challenge(challenger, acceptor, dare)
    @challenger = challenger
    @acceptor = acceptor  
    @dare = dare
    mail(to: @acceptor.email, subject: "You rejected #{@challenger.username.capitalize}'s challenge!")
  end

  def acceptor_uploaded_proof(challenger, acceptor, dare)
    @challenger = challenger
    @acceptor = acceptor  
    @dare = dare
    mail(to: @challenger.email, subject: "#{@acceptor.username.capitalize} uploaded proof of completion of your challenge. Check it out!")
  end

  def challenger_accepted_proof(challenger, acceptor, dare)
    @challenger = challenger
    @acceptor = acceptor  
    @dare = dare
    mail(to: @acceptor.email, subject: "#{@challenger.username.capitalize} has accepted your proof! Hurray, you won!")
  end

  def accepted_proof(challenger, acceptor, dare)
    @challenger = challenger
    @acceptor = acceptor  
    @dare = dare
    mail(to: @challenger.email, subject: "You accepted #{@acceptor.username.capitalize}'s' proof. Let's celebrate!")
  end

  def challenger_rejected_proof(challenger, acceptor, dare)
    @challenger = challenger
    @acceptor = acceptor  
    @dare = dare
    mail(to: @acceptor.email, subject: "#{@challenger.username.capitalize} has rejected your proof!")
  end

  def rejected_proof(challenger, acceptor, dare)
    @challenger = challenger
    @acceptor = acceptor  
    @dare = dare
    mail(to: @challenger.email, subject: "You rejected #{@acceptor.username.capitalize}'s proof!")
  end

  def voting_started(challenger, acceptor, dare)
    @challenger = challenger
    @acceptor = acceptor  
    @dare = dare
    recipients = [@challenger.email, @acceptor.email]
    mail(to: recipients, subject: "#{@dare.challenge.name} was put to the vote!")
  end

  def acceptor_voting_ended(challenger, acceptor, dare)
    @challenger = challenger
    @acceptor = acceptor  
    @dare = dare
    mail(to: @acceptor.email, subject: "The voting for #{@dare.challenge.name} has ended!")
  end

  def challenger_voting_ended(challenger, acceptor, dare)
    @challenger = challenger
    @acceptor = acceptor  
    @dare = dare
    mail(to: @challenger.email, subject: "The voting for #{@dare.challenge.name} has ended!")
  end

  def challenger_no_proof_fail(challenger, acceptor, dare)
    @challenger = challenger
    @acceptor = acceptor  
    @dare = dare
    mail(to: @challenger.email, subject: "#{@acceptor.username.capitalize}  failed the #{@dare.challenge.name} challenge!", template_name: 'challenger_no_proof_fail')
  end

  def acceptor_no_proof_fail(challenger, acceptor, dare)
    @challenger = challenger
    @acceptor = acceptor  
    @dare = dare
    mail(to: @acceptor.email, subject: "You have failed the #{@dare.challenge.name} challenge!")
  end
end
