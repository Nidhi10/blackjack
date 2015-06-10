class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :number
      t.integer :points
      t.integer :deck

      t.timestamps null: false
    end
  end
end
