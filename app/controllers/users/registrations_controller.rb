class RegistrationsController < Devise::RegistrationsController
  # skip_before_filter :require_no_authentication
  protected

  def after_sign_up_path_for(resource)
    session[:previous_url] || challenges_path
  end
end