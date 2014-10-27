class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :configure_permitted_parameters, if: :devise_controller?
  after_filter :store_location

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :username
    devise_parameter_sanitizer.for(:sign_in) << :username
    devise_parameter_sanitizer.for(:account_update) << :username
    devise_parameter_sanitizer.for(:sign_up) << :email
    devise_parameter_sanitizer.for(:sign_in) << :email
    devise_parameter_sanitizer.for(:account_update) << :email
    devise_parameter_sanitizer.for(:sign_up) << :provider
    devise_parameter_sanitizer.for(:sign_in) << :provider
    devise_parameter_sanitizer.for(:account_update) << :provider
    devise_parameter_sanitizer.for(:sign_up) << :uid
    devise_parameter_sanitizer.for(:sign_in) << :uid
    devise_parameter_sanitizer.for(:account_update) << :uid
    devise_parameter_sanitizer.for(:sign_up) << :oauth_token
    devise_parameter_sanitizer.for(:sign_in) << :oauth_token
    devise_parameter_sanitizer.for(:account_update) << :oauth_token
    devise_parameter_sanitizer.for(:sign_up) << :oauth_expires_at
    devise_parameter_sanitizer.for(:sign_in) << :oauth_expires_at
    devise_parameter_sanitizer.for(:account_update) << :oauth_expires_at
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
  if (request.path != "/users/sign_in" &&
      request.path != "/users/sign_up" &&
      request.path != "/users/password/new" &&
      request.path != "/users/password/edit" &&
      request.path != "/users/confirmation" &&
      request.path != "/users/sign_out" &&
      !request.xhr?) # don't store ajax calls
    session[:previous_url] = request.fullpath 
  end
end

def after_sign_in_path_for(resource)
  session[:previous_url] || root_path
end
  
end
