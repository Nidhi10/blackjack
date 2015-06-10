class CreateMoveCards < ActiveRecord::Migration
  def change
    create_table :move_cards do |t|
      t.references :move, index: true, foreign_key: true
      t.references :card, index: true, foreign_key: true
      t.index [:move_id, :card_id], unique: true
      t.timestamps null: false
    end
  end
end
