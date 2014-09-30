class DaresController < ApplicationController

  def create
    @challenge = Challenge.find(params[:challenge_id])
    @user = params[:user] ? User.find(params[:user]) : current_user

    @fail_alert = params[:user] ? "#{@user.username} already accepted this challenge" : "You have already accepted #{@challenge.name}"
    @success_alert = params[:user] ? "You challenged #{@user.username} to #{@challenge.name} challenge" : "You accepted #{@challenge.name}"

    if @user.dares.map{ |e| e.challenge_id  }.include?(@challenge.id)
      redirect_to :root, alert: @fail_alert 
    else
      Dare.create(acceptor_id: @user.id, challenge_id: @challenge.id, challenger_id: @user.id, status: "Accepted")
      redirect_to :root, notice: @success_alert
    end 
  end

  def update
    @dare = Dare.find(params[:id])
    if @dare.update(dare_params)
      redirect_to root_path
    else
      render "/challenges/index"
    end
  end

  private

  def dare_params
    params.require(:dare).permit(:status, :acceptor_id, :challenger_id, :challenge_id)
  end

end
