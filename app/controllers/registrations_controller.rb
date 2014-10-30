class RegistrationsController < Devise::RegistrationsController
  # skip_before_filter :require_no_authentication
  # prepend_before_filter :require_no_authentication, only: [ :new, :create, :cancel ]
  # prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy, :show]
  # after_filter :enable_show_about_fb

  def update
    # For Rails 4
    account_update_params = devise_parameter_sanitizer.sanitize(:account_update)
    # For Rails 3
    # account_update_params = params[:user]

    # required for settings form to submit when password is left blank
    if account_update_params[:password].blank?
      account_update_params.delete("password")
      account_update_params.delete("password_confirmation")
    end

    @user = User.find(current_user.id)
    if @user.update_attributes(account_update_params)
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case their password changed
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      render "edit"
    end
  end

  protected

  def after_sign_up_path_for(resource)
    challenges_path
  end

  # def enable_show_about_fb
  #   session[:about_fb] = true
  # end
end