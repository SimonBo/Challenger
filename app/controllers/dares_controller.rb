class DaresController < ApplicationController

  def show
    dare = Dare.find(params[:id])
  end




  def create
    if params[:dare]
      @dare = Dare.new(dare_params)
      if @dare.save_with_payment(params[:stripe_card_token], current_user)
        redirect_to root_path, :notice => "Thank you for betting!"
      else
        redirect_to new_challenge_dare_path, notice: 'Failed'
      end

    else
      @challenge = Challenge.find(params[:challenge_id])
      @user = params[:user] ? User.find(params[:user]) : current_user

      fail_alert = params[:user] ? "#{@user.username} already accepted this challenge" : "You have already accepted #{@challenge.name}"
      success_alert = params[:user] ? "You challenged #{@user.username} to #{@challenge.name} challenge" : "You accepted #{@challenge.name}"
      
        if @user.dares.map{ |e| e.challenge_id  }.include?(@challenge.id)
          redirect_to :root, alert: fail_alert 
        else
          Dare.create(acceptor_id: @user.id, challenge_id: @challenge.id, challenger_id: @user.id, status: "Accepted", :start_date: DateTime.now)
          redirect_to :root, notice: success_alert
        end    
    end

    
  end











  def new
    @dare = Dare.new
    @challenge = Challenge.find(params[:challenge_id])
  end

  def update
    @dare = Dare.find(params[:id])
    if @dare.update(dare_params)
      if params[:dare][:vid_link]
        if params[:dare][:vid_link].empty?
          redirect_to challenge_dare_path(params[:challenge_id], @dare), notice: 'Link to video not provided'
        else
          vid_link = YouTubeAddy.extract_video_id(params[:dare][:vid_link])
          @dare.utube_link = @dare.utube_link + [vid_link]
          @dare.save
          redirect_to challenge_dare_path(params[:challenge_id], @dare), notice: 'Added proof'
        end
      end
      redirect_to root_path
      # redirect_to challenge_dare_path(params[:challenge_id], @dare), notice: 'Dare updated'
    else
      redirect_to root_path, notice: 'Something went wrong'
    end
  end

  private

  def dare_params
    params.require(:dare).permit(:status, :amount, :acceptor_id, :challenger_id, :challenge_id, :utube_link, :start_date, :end_date)
  end

end
