class DaresController < ApplicationController

  def create
    @challenge = Challenge.find(params[:challenge_id])
    @user = params[:user] ? User.find(params[:user]) : current_user

    if @user.dares.map{ |e| e.challenge_id  }.include?(@challenge.id)
      redirect_to :root, alert: "You already accepted this challenge" 
    else
      Dare.create(acceptor_id: @user.id, challenge_id: @challenge.id, challenger_id: @user.id, status: "Accepted")
      redirect_to :root, notice: "#{@user.username} accepted #{@challenge.name}"
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
