class MovesController < ApplicationController
  before_action :authenticate_player!

  def index
    @game = Game.find(params[:game_id])
    @moves = @game.moves.includes(:cards, :player)
  end

  def show
    @move = Move.where(game_id: params[:game_id], player_id: current_player.id).where(status: '').find(params[:id])
  end

  def update
    @move = Move.includes(:game).where(game_id: params[:game_id], player_id: current_player.id).find(params[:id])
    if @move.update(move_params)
      redirect_to @move.game
    end
  end

  private
    def move_params
      params.require(:move).permit(:status)
    end
end
