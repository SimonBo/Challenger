class DaresController < ApplicationController

  def delete_proof
    @dare = Dare.find(params[:id])
    @dare.utube_link.delete(params[:proof_id])
    @dare.save
    binding.pry
    redirect_to challenge_dare_url(@dare.challenge_id, @dare.id)
  end

  def show
    @dare = Dare.find(params[:id])
    @vote = Vote.new
  end




  def create
    @challenge = Challenge.find(params[:challenge_id])
    @dare = Dare.new(dare_params)
    if params[:dare][:with_bet] == "1"
      @dare.prepare_with_payment(params[:stripe_card_token], current_user)
      # acceptor = User.find(params[:dare][:acceptor_id])      
    end
    if @dare.save
      redirect_to root_path, notice: 'Success'
    else
      redirect_to root_path, alert: 'There was a problem, try again!'
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
          redirect_to challenge_dare_path(params[:challenge_id], @dare), alert: 'Link to video not provided'
        else
          vid_link = YouTubeAddy.extract_video_id(params[:dare][:vid_link])
          if vid_link.length == 11
            @dare.utube_link = @dare.utube_link + [vid_link]
            @dare.save
            redirect_to challenge_dare_path(params[:challenge_id], @dare), notice: 'Added proof'
          else
            redirect_to challenge_dare_path(params[:challenge_id], @dare), alert: 'The link is not a valid Youtube link'
          end
        end
      end
    else
      redirect_to root_path, notice: 'Something went wrong'
    end
  end

  def destroy
    @dare = Dare.find(params[:id])
    @dare.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Dare was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


private

def dare_params
  params.require(:dare).permit(:status, :amount, :acceptor_id, :challenger_id, :challenge_id, :utube_link, :start_date, :end_date, :with_bet, :vid_link)
end

end
