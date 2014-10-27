class RegistrationsController < Devise::RegistrationsController
  # skip_before_filter :require_no_authentication
  # prepend_before_filter :require_no_authentication, only: [ :new, :create, :cancel ]
  # prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy, :show]

  protected

  def after_sign_up_path_for(resource)
    session[:previous_url] || challenges_path
  end
end