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
end
