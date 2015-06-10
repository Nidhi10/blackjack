class GamesController < ApplicationController
  before_action :authenticate_player!
  before_action :get_games_for_current_player

  def index
    @games = @games.includes(:winner)
  end

  def show
    @game = @games.find(params[:id])
    # show the sum of points. If it's the first move, we don't show system score, else we do
    @my_points = Move.total_points current_player.id, @game.id
    if @game.moves.size > 2
      @system_points = Move.total_points Player::SYSTEM, @game.id
    end
  end

  def new
    @game = @games.build
  end

  def create
    @game = @games.build(game_params)
    if @game.save
      redirect_to @game, notice: 'Game has started!'
    else
      render 'new'
    end
  end


  private

    def game_params
      params.require(:game).permit(:bet)
    end

    def get_games_for_current_player
      @games = current_player.games
    end
end
