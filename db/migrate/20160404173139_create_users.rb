class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.text :password_hash
      t.integer :wins, null: false, default: 0
      t.integer :losses, null: false, default: 0
      t.text :bio

      t.timestamps null: false
    end
  end
end
