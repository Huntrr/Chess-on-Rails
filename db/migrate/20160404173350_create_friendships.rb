class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.references :user, index: true, foreign_key: true
      t.references :friend, index: true, foreign_key: true
      t.boolean :accepted, null: false, default: false

      t.timestamps null: false
    end
  end
end
