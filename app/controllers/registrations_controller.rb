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

  def create
    build_resource(sign_up_params)

    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      if params[:token].present?
        invitation = Invitation.where("token = ?", params[:token]).first
        dare = invitation.dare
        dare.acceptor_id = @user.id
        dare.status = 'Accepted'
        dare.start_date = DateTime.now
        dare.save!
        UserMailer.user_accepted_challenge(dare.challenger, dare.acceptor, dare).deliver
        UserMailer.you_accepted_challenge(dare.challenger, dare.acceptor, dare).deliver
        dare.post_on_fb("accepted_challenge")
      end
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      @validatable = devise_mapping.validatable?
      if @validatable
        @minimum_password_length = resource_class.password_length.min
      end
      respond_with resource
    end
  end

  protected

  def after_sign_up_path_for(resource)
    if params[:token].present?
      session[:previous_url]
    else
      challenges_path
    end
  end

  # def enable_show_about_fb
  #   session[:about_fb] = true
  # end
end