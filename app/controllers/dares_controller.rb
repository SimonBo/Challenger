class DaresController < ApplicationController

  def create
    @user = User.find(params[:user])
    @challenge = Challenge.find(params[:challenge_id])
    if @user.dares.map{ |e| e.challenge_id  }.include?(@challenge.id)
      redirect_to :root, alert: "#{@user.username} already accepted this challenge" 
    else
      Dare.create(acceptor_id: @user.id, challenger_id: current_user.id, challenge_id: @challenge.id)
      redirect_to :root, notice: "You challenged #{@user.username} to #{@challenge.name}"
    end
  end

  def update
    @dare = Dare.find(params[:id])
    binding.pry
    if @dare.update(dare_params)
      redirect_to root_path
    else
      render "/challenges/index"
    end
  end

  private

  def dare_params
    params.require(:dare).permit(:status)
  end

end
