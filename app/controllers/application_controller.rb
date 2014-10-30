class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :configure_permitted_parameters, if: :devise_controller?
  after_filter :store_location
  before_filter :store_email_from_invitation

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:username, :email, :password, :password_confirmation, :can_post, :email, :oauth_expires_at, :oauth_token, :provider, :uid)
    end

    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:username, :email, :password, :password_confirmation, :can_post, :email, :oauth_expires_at, :oauth_token, :provider, :uid)
    end

    devise_parameter_sanitizer.for(:sign_in) do |u|
      u.permit(:username, :email, :password, :password_confirmation, :can_post, :email, :oauth_expires_at, :oauth_token, :provider, :uid)
    end
  end

  def after_sign_in_path_for(resource_or_scope)
    session[:previous_url] || challenges_path
  end

  def after_sign_out_path_for(resource_or_scope)
    challenges_path
  end



  def store_location
  # store last url - this is needed for post-login redirect to whatever the user last visited.
  return unless request.get? 
  if params[:token].present?
    invitation = Invitation.where("token = ?", params[:token]).first
    dare = invitation.dare
    challenge = dare.challenge
    session[:previous_url] = challenge_dare_path(challenge, dare)
  elsif (request.path != "/users/sign_in" &&
    request.path != "/users/sign_up" &&
    request.path != "/users/sign_up/:token" &&
    request.path != "/users/password/new" &&
    request.path != "/users/password/edit" &&
    request.path != "/users/confirmation" &&
    request.path != "/users/sign_out" &&
      !request.xhr?) # don't store ajax calls
  session[:previous_url] = request.fullpath 
end
end

def set_dare_from_invitation
  if params[:token].present?
    invitation = Invitation.where("token = ?", params[:token]).first
    dare = invitation.dare
    challenge = dare.challenge
    session[:previous_url] = challenge_dare_path(challenge, dare)
  end
end


def store_email_from_invitation
  if params[:token].present?
    invitation = Invitation.where("token = ?", params[:token]).first
    @new_user_email = invitation.recipient_email
    # @new_user_email = Rails.cache.fetch("new_user_email") do 
    #   invitation.recipient_email
    # end

  end
end

end
