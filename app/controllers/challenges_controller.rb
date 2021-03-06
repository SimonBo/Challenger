class ChallengesController < ApplicationController
  before_action :set_challenge, except: [:index,:new, :create, :popular_challenges, :intro]
  respond_to :js

  def intro
  end

  def index
    @challenges = Challenge.text_search(params[:query])

    if params[:choice]
      direction = params[:choice].end_with?("1") ? "ASC" : "DESC"
    end

    @sorted_challenges = case params[:choice]
    when "popular", "popular1"
      Challenge.order("dares_count #{direction}")
    when "date", "date1"
      Challenge.order("created_at #{direction}")
    when "name", "name1"
      Challenge.order("name #{direction}")
    end
  end

  def show
  end

  def new
    @challenge = Challenge.new
  end

  def edit
  end

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

  def destroy
    @challenge.destroy
    respond_to do |format|
      format.html { redirect_to challenges_url, notice: 'Challenge was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private

  def set_challenge
    @challenge = Challenge.find(params[:id])
  end


  def challenge_params
    params.require(:challenge).permit(:user_id, :name, :description)
  end
end
