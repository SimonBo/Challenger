class UsersController < ApplicationController

  respond_to :js

  def index
    @users = User.sorted_by_accepted_dares
  end

  def search
    @users = User.text_search(params[:query])
  end

  
  def show
    @user=User.find(params[:id])
    @challenged_users = @user.dares.where.not(acceptor_id: @user.id)
  end


end
