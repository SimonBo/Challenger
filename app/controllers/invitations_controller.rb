class InvitationsController < ApplicationController
  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.user_id = current_user.id

    if @invitation.save!
        challenge = params[:invitation][:challenge_id]
        @invitation.prepare_dare(challenge)
        UserMailer.deliver_invitation(@invitation)
        flash[:notice] = "Thank you, invitation sent."
        redirect_to challenges_path
    else
      render :new
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:user_id, :recipient_email, :dare_id, :token, :status, :challenge_id)
  end
end