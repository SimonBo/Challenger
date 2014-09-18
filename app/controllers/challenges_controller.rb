class ChallengesController < ApplicationController
  before_action :set_challenge, only: [:show, :edit, :update, :destroy, :accept_challenge, :challenge_others, :challenge_user]
  respond_to :js

  def accept_challenge
    if current_user.accepted_challenges.include?(@challenge)
      redirect_to :root, warning: "You already accepted this challenge" 
    else
      current_user.accepted_challenges << @challenge
      redirect_to :root, notice: "You accepted #{@challenge.name}"
    end 
  end

  def challenge_others
  end

  def challenge_user
    user.pending_challenges << @challenge
    current_user
  end
  # GET /challenges
  # GET /challenges.json
  def index
    @challenges = Challenge.all
  end

  # GET /challenges/1
  # GET /challenges/1.json
  def show
  end

  # GET /challenges/new
  def new
    @challenge = Challenge.new
  end

  # GET /challenges/1/edit
  def edit
  end

  # POST /challenges
  # POST /challenges.json
  def create
    @challenge = Challenge.new(challenge_params)

    respond_to do |format|
      if @challenge.save
        format.html { redirect_to @challenge, notice: 'Challenge was successfully created.' }
        format.js 
      else
        format.html { render :new }
        format.js
      end
    end
  end

  # PATCH/PUT /challenges/1
  # PATCH/PUT /challenges/1.json
  def update
    respond_to do |format|
      if @challenge.update(challenge_params)
        format.html { redirect_to @challenge, notice: 'Challenge was successfully updated.' }
        format.json { render :show, status: :ok, location: @challenge }
      else
        format.html { render :edit }
        format.json { render json: @challenge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /challenges/1
  # DELETE /challenges/1.json
  def destroy
    @challenge.destroy
    respond_to do |format|
      format.html { redirect_to challenges_url, notice: 'Challenge was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_challenge
      @challenge = Challenge.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def challenge_params
      params.require(:challenge).permit(:user_id, :name, :description)
    end
end
