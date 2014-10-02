class DaresController < ApplicationController

  def show
    @dare = Dare.find(params[:id])
  end
  def create
    @dare = Dare.new(dare_params)

    if @dare.save_with_payment(params[:stripe_card_token], current_user)
      redirect_to root_path, :notice => "Thank you for betting!"
    else
      redirect_to new_challenge_dare_path, notice: 'Failed'
    end
  end

  def new
    @dare = Dare.new
    @challenge = Challenge.find(params[:challenge_id])
  end

  def update
    @dare = Dare.find(params[:id])
    if @dare.update(dare_params)
      utube_link = YouTubeAddy.extract_video_id(@dare.vid_link)
      @dare.vid_link = utube_link
      @dare.save
      redirect_to root_path
    else
      render "/challenges/index"
    end
  end

  private

  def dare_params
    params.require(:dare).permit(:status, :amount, :acceptor_id, :challenger_id, :challenge_id, :vid_link)
  end

end
