# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_12_08_212653) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "players", force: :cascade do |t|
    t.string "full_name"
    t.bigint "team_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_id"], name: "index_players_on_team_id"
  end

  create_table "positions", force: :cascade do |t|
    t.string "name"
    t.string "abbr"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "rush_stats", force: :cascade do |t|
    t.integer "attempts_per_game"
    t.decimal "attempts"
    t.integer "total_yards"
    t.decimal "avg_yards_per_attempt"
    t.decimal "yards_per_game"
    t.integer "total_touchdowns"
    t.integer "longest"
    t.boolean "touchdown"
    t.integer "first_down"
    t.decimal "first_down_percent"
    t.integer "twenty_yards_each"
    t.integer "forty_yards_each"
    t.integer "fumbles"
    t.bigint "player_id", null: false
    t.bigint "position_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["player_id"], name: "index_rush_stats_on_player_id"
    t.index ["position_id"], name: "index_rush_stats_on_position_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "abbr"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "players", "teams"
  add_foreign_key "rush_stats", "players"
  add_foreign_key "rush_stats", "positions"
end
