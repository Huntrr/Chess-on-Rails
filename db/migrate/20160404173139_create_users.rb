class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.text :password_hash
      t.integer :wins
      t.integer :losses
      t.integer :rating
      t.text :bio

      t.timestamps null: false
    end
  end
end
