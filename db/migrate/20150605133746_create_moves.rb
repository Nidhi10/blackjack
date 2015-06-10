class CreateMoves < ActiveRecord::Migration
  def change
    create_table :moves do |t|
      t.references :game, index: true, foreign_key: true
      t.references :player, index: true, foreign_key: true
      t.references :last_move
      t.string :status, default: ''

      t.index [:player_id, :last_move_id], unique: true
      t.timestamps null: false
    end
  end
end
