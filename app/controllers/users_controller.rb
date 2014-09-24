class UsersController < ApplicationController

  def show
    @user=User.find(params[:id])
    @challenged_users = @user.dares.where.not(acceptor_id: current_user.id)
  end


end
