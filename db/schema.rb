# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160404173350) do

  create_table "friendships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.boolean  "accepted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "friendships", ["friend_id"], name: "index_friendships_on_friend_id"
  add_index "friendships", ["user_id"], name: "index_friendships_on_user_id"

  create_table "games", force: :cascade do |t|
    t.integer  "white_player_id"
    t.integer  "black_player_id"
    t.text     "game_state"
    t.boolean  "allow_undos",     default: true,  null: false
    t.boolean  "sandbox_mode",    default: false, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "games", ["black_player_id"], name: "index_games_on_black_player_id"
  add_index "games", ["white_player_id"], name: "index_games_on_white_player_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.text     "password_hash"
    t.integer  "wins",          default: 0,    null: false
    t.integer  "losses",        default: 0,    null: false
    t.integer  "rating",        default: 1000, null: false
    t.text     "bio"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

end
