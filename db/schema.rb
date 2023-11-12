# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_11_12_174209) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "rabbit_speeches", force: :cascade do |t|
    t.string "text", null: false
    t.json "colored_words", default: [], null: false
    t.bigint "rabbit_id", null: false
    t.bigint "next_speech_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["next_speech_id"], name: "index_rabbit_speeches_on_next_speech_id"
    t.index ["rabbit_id"], name: "index_rabbit_speeches_on_rabbit_id"
  end

  create_table "rabbits", force: :cascade do |t|
    t.string "name", null: false
    t.integer "color", null: false
    t.integer "difficulty", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "session_rabbits", force: :cascade do |t|
    t.bigint "rabbit_id", null: false
    t.bigint "session_id", null: false
    t.integer "status", default: 0
    t.string "uuid", null: false
    t.string "key", null: false
    t.boolean "found_animation_played", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rabbit_id"], name: "index_session_rabbits_on_rabbit_id"
    t.index ["session_id"], name: "index_session_rabbits_on_session_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "uuid", null: false
    t.integer "status", default: 0
    t.bigint "current_advice_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["current_advice_id"], name: "index_sessions_on_current_advice_id"
  end

  add_foreign_key "rabbit_speeches", "rabbit_speeches", column: "next_speech_id"
  add_foreign_key "rabbit_speeches", "rabbits"
  add_foreign_key "session_rabbits", "rabbits"
  add_foreign_key "session_rabbits", "sessions"
  add_foreign_key "sessions", "rabbit_speeches", column: "current_advice_id"
end
