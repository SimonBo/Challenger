class UsersController < ApplicationController

  def index
    @users = User.sorted_by_accepted_dares
  end
  
  def show
    @user=User.find(params[:id])
    @challenged_users = @user.dares.where.not(acceptor_id: @user.id)
  end


end
