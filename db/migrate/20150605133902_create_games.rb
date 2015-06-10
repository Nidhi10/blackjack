class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.references :player, index: true, foreign_key: true
      t.references :winner, index: true, foreign_key: true
      t.integer :points, default: 0
      t.float :bet
      t.boolean :finished, default: false

      t.timestamps null: false
    end
  end
end
