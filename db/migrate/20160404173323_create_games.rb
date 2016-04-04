class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.references :white_player, index: true, foreign_key: true
      t.references :black_player, index: true, foreign_key: true
      t.text :game_state
      t.boolean :allow_undos
      t.boolean :sandbox_mode

      t.timestamps null: false
    end
  end
end
