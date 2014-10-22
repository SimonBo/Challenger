class UsersController < ApplicationController

  respond_to :js

  def index
    @users = User.sorted_by_accepted_dares
  end

  def autocomplete
    @users = User.order("username, email").where("username ILIKE ? OR email ILIKE ?", "%#{params[:term]}%", "%#{params[:term]}%")
    render json: @users.map(&:username)
  end

  def search
    @users = User.text_search(params[:query])
    @dare = Dare.new
    @challenge = Challenge.find(params[:challenge])
  end

  
  def show
    @user=User.find(params[:id])
    @challenged_users = @user.dares.where.not(acceptor_id: @user.id)
  end

  

end
