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
    mail(to: @challenger.email, subject: "You accepted #{@acceptor.username.capitalize}'s' proof. Let's celebrate!")
  end



end
