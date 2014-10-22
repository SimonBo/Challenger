class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :configure_permitted_parameters, if: :devise_controller?

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
    challenges_path
  end

  def after_sign_out_path_for(resource_or_scope)
    challenges_path
  end
  
end
