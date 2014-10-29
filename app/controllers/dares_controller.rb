class DaresController < ApplicationController
  before_action :set_dare, except: [:index, :new, :create, :show_voting, :show_invitation_dare]
  before_action :authenticate_user!, except: :show_invitation_dare
  before_action :set_challenger_acceptor, only: [:create]  

  def show_invitation_dare
      @invitation = Invitation.where("token = ?", params[:token]).first
      @dare = Dare.where("invitation_id = ?", @invitation.id).first
    if @dare.status != 'Invitation-pending'
      redirect_to challenge_dare_path(@dare.challenge_id, @dare.id), notice: 'This invitation has already been processed'
    end
  end

  def show_voting
    @dares_voting = Dare.where('status = ?', 'Voting')
  end

  def accept_challenge
    if @dare.status = 'Invitation-pending'
      @dare.acceptor_id = current_user.id
    end
    @dare.status = 'Accepted'
    @dare.start_date = DateTime.now
    if @dare.save
      UserMailer.user_accepted_challenge(@dare.challenger, @dare.acceptor, @dare).deliver
      UserMailer.you_accepted_challenge(@dare.challenger, @dare.acceptor, @dare).deliver
      @dare.post_on_fb("accepted_challenge")
      redirect_to challenge_dare_url(@dare.challenge_id, @dare.id), notice: 'You accepted the challenge!'
    else
      redirect_to challenge_dare_url(@dare.challenge_id, @dare.id), notice: 'Something went wrong!'
    end
  end

  def reject_challenge
    @dare.status = 'Rejected'
    @dare.end_date = DateTime.now
    if @dare.save
      UserMailer.user_rejected_challenge(@dare.challenger, @dare.acceptor, @dare).deliver
      UserMailer.you_rejected_challenge(@dare.challenger, @dare.acceptor, @dare).deliver
      redirect_to challenge_dare_url(@dare.challenge_id, @dare.id), alert: 'You rejected the challenge!'
    else
      redirect_to challenge_dare_url(@dare.challenge_id, @dare.id), notice: 'Something went wrong!'
    end
  end

  def accept_proof
    @dare.status = 'Success'
    @dare.proof_status = 'Accepted'
    if @dare.save
      UserMailer.challenger_accepted_proof(@dare.challenger, @dare.acceptor, @dare).deliver
      UserMailer.accepted_proof(@dare.challenger, @dare.acceptor, @dare).deliver
      redirect_to challenge_dare_url(@dare.challenge_id, @dare.id), notice: 'You accepted the proof!'
    else
      redirect_to challenge_dare_url(@dare.challenge_id, @dare.id), notice: 'Something went wrong!'
    end
  end

  def reject_proof
    @dare.status = 'Voting'
    @dare.proof_status = 'Rejected' unless @dare.is_self_selected?
    @dare.voting_start_date = DateTime.now
    if @dare.save
      if @dare.is_self_selected?
        UserMailer.self_selected_voting_started(@dare.challenger, @dare).deliver
        redirect_to challenge_dare_url(@dare.challenge_id, @dare.id), notice: 'You finished uploading proof!'
      else
        UserMailer.challenger_rejected_proof(@dare.challenger, @dare.acceptor, @dare).deliver
        UserMailer.rejected_proof(@dare.challenger, @dare.acceptor, @dare).deliver
        UserMailer.voting_started(@dare.challenger, @dare.acceptor, @dare).deliver
        redirect_to challenge_dare_url(@dare.challenge_id, @dare.id), notice: 'You rejected the proof!'
      end
    else
      redirect_to challenge_dare_url(@dare.challenge_id, @dare.id), notice: 'Something went wrong!'
    end
  end

  def delete_proof
    if params[:proof_type] == 'pic'
      @dare.pic_link.delete_at(params[:proof_id].to_i)
      @dare.pic_link_will_change!
    else
      @dare.utube_link.delete(params[:proof_id])
      @dare.utube_link_will_change!
    end
    if @dare.save
      redirect_to challenge_dare_url(@dare.challenge_id, @dare.id), notice: 'Proof deleted!'
    else
      redirect_to challenge_dare_url(@dare.challenge_id, @dare.id), notice: 'Something went wrong!'
    end
  end


  def show
    @vote = Vote.new
  end


  def create
    @challenge = Challenge.find(params[:challenge_id])
    @dare = Dare.new(dare_params)

    if @dare.save
      if params[:dare][:challenger_id] == params[:dare][:acceptor_id]
        UserMailer.self_challenge(@challenger, @dare).deliver
        redirect_to challenge_dare_path(@challenge, @dare), notice: 'You accepted the challenge!'
      else
        UserMailer.you_challenged(@challenger, @acceptor, @dare).deliver
        UserMailer.you_were_challenged(@challenger, @acceptor, @dare).deliver
        redirect_to challenge_dare_path(@challenge, @dare), notice: "You challenged #{@acceptor.username} to #{@challenge.name}!"
      end
    else
      render :new
    end  
  end

  def new
    @dare = Dare.new
    @challenge = Challenge.find(params[:challenge_id])
    @invitation = Invitation.new
  end



  def update
    if @dare.update(dare_params)
      if params[:dare][:vid_link]
        if params[:dare][:vid_link].empty?
          redirect_to challenge_dare_path(params[:challenge_id], @dare), alert: 'Link to video not provided'
        else
          vid_link = YouTubeAddy.extract_video_id(params[:dare][:vid_link])
          if vid_link.length == 11
            @dare.utube_link = @dare.utube_link + [vid_link]
            @dare.save!
            @dare.post_on_fb("uploaded_proof")
            if @dare.is_self_selected?
              redirect_to challenge_dare_path(params[:challenge_id], @dare), notice: 'Added proof'
            else
              UserMailer.acceptor_uploaded_proof(@dare.challenger, @dare.acceptor, @dare).deliver
              redirect_to challenge_dare_path(params[:challenge_id], @dare), notice: 'Added proof'
            end
          else
            redirect_to challenge_dare_path(params[:challenge_id], @dare), alert: 'The link is not a valid Youtube link'
          end
        end
      elsif params[:dare][:pic_link]
        @dare.pic_link = @dare.pic_link + [params[:dare][:pic_link]]
        @dare.save!
        redirect_to challenge_dare_path(params[:challenge_id], @dare), notice: 'Added proof'
      else
        redirect_to challenges_path, notice: 'Yay!'
      end
    else
      redirect_to root_path, notice: 'Something went wrong'
    end
  end

  def destroy
    @dare.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Dare was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private

  def set_dare
    @dare = Dare.find(params[:id])
  end

  def set_challenger_acceptor   
    @challenger = User.find(params[:dare][:challenger_id])
    @acceptor = User.find(params[:dare][:acceptor_id])
  end

  def dare_params
    params.require(:dare).permit(:status, :amount, :acceptor_id, :challenger_id, :challenge_id, :utube_link, :start_date, :end_date, :with_bet, :vid_link, :pic_link)
  end

end
