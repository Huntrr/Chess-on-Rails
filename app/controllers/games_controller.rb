class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  # GET /games
  # GET /games.json
  def index
    @games = Game.all
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @side = @game.black_player.id == current_user.id ? 'black' : 'white'
    @playing = @game.black_player.id == current_user.id || @game.white_player.id == current_user.id
  end

  # GET /games/new
  def new
    @game = Game.new
    @opponent_id = params[:opponent_id]
  end

  # POST /games
  def create
    @game = setup_game(game_params)

    if @game.save
      @game.update_players
      redirect_to @game, notice: 'Game was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    @game.update_players
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.update_players
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def setup_game(game_params)
    gp = game_params
    if gp[:white_player].to_i == 1
      gp[:white_player] = current_user
      gp[:black_player] = User.find(game_params[:opponent_id])
    else
      gp[:white_player] = User.find(game_params[:opponent_id])
      gp[:black_player] = current_user
    end

    gp.delete :opponent_id
    Game.new(gp)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_game
    @game = Game.find(params[:id])
    @opponent_id = 0
    @opponent_id = params[:opponent_id] unless params[:opponent_id].nil?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def game_params
    params.require(:game).permit(:white_player, :opponent_id, :game_state, :allow_undos, :sandbox_mode, :result)
  end
end
