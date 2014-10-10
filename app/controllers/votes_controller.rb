class VotesController < ApplicationController
  before_action :set_vote, only: [:show, :edit, :update, :destroy]
  # GET /votes
  # GET /votes.json
  def index
    @votes = Vote.all
  end

  # GET /votes/1
  # GET /votes/1.json
  def show
  end

  # GET /votes/new
  def new
    @vote = Vote.new

  end

  # GET /votes/1/edit
  def edit
  end

  # POST /votes
  # POST /votes.json
  def create

    @vote = Vote.new(vote_params)
    @vote.user_id = current_user.id
    @vote.dare_id = params[:dare_id]


    respond_to do |format|
      if @vote.save
        format.html { redirect_to challenge_dare_url(params[:challenge_id], params[:dare_id]), notice: 'Vote accepted!' }
        format.json { render :show, status: :created, location: @vote }
      else
        format.html { redirect_to challenge_dare_url(challenge_id, dare_id), notice: 'Something went wrong, sorry!'  }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /votes/1
  # PATCH/PUT /votes/1.json
  def update
    respond_to do |format|
      if @vote.update(vote_params)
        format.html { redirect_to @vote, notice: 'Vote was successfully updated.' }
        format.json { render :show, status: :ok, location: @vote }
      else
        format.html { render :edit }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /votes/1
  # DELETE /votes/1.json
  def destroy
    @vote.destroy
    respond_to do |format|
      format.html { redirect_to votes_url, notice: 'Vote was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vote
      @vote = Vote.find(params[:id])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def vote_params
      params.require(:vote).permit(:vote_for, :user_id, :dare_id)
    end
  end
