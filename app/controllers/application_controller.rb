class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :users_challenged_by_me

  def users_challenged_by_me
    @challenged = current_user.dares.where.not(acceptor_id: current_user.id)
  end
end
