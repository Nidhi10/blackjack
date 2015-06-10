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

ActiveRecord::Schema.define(version: 20150605183227) do

  create_table "cards", force: :cascade do |t|
    t.string   "number"
    t.integer  "points"
    t.integer  "deck"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "games", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "winner_id"
    t.integer  "points",     default: 0
    t.float    "bet"
    t.boolean  "finished",   default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "games", ["player_id"], name: "index_games_on_player_id"
  add_index "games", ["winner_id"], name: "index_games_on_winner_id"

  create_table "move_cards", force: :cascade do |t|
    t.integer  "move_id"
    t.integer  "card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "move_cards", ["card_id"], name: "index_move_cards_on_card_id"
  add_index "move_cards", ["move_id", "card_id"], name: "index_move_cards_on_move_id_and_card_id", unique: true
  add_index "move_cards", ["move_id"], name: "index_move_cards_on_move_id"

  create_table "moves", force: :cascade do |t|
    t.integer  "game_id"
    t.integer  "player_id"
    t.integer  "last_move_id"
    t.string   "status",       default: ""
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "moves", ["game_id"], name: "index_moves_on_game_id"
  add_index "moves", ["player_id", "last_move_id"], name: "index_moves_on_player_id_and_last_move_id", unique: true
  add_index "moves", ["player_id"], name: "index_moves_on_player_id"

  create_table "players", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "name"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "players", ["email"], name: "index_players_on_email", unique: true
  add_index "players", ["reset_password_token"], name: "index_players_on_reset_password_token", unique: true

end
