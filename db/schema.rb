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

ActiveRecord::Schema[7.1].define(version: 2023_11_16_175109) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "rabbits", force: :cascade do |t|
    t.string "name", null: false
    t.integer "color", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "session_rabbits", force: :cascade do |t|
    t.bigint "rabbit_id", null: false
    t.bigint "session_id", null: false
    t.integer "status", default: 0
    t.string "uuid", null: false
    t.string "key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "current_speech_id"
    t.integer "speech_status", default: 0
    t.integer "speech_type", default: 0
    t.index ["current_speech_id"], name: "index_session_rabbits_on_current_speech_id"
    t.index ["rabbit_id"], name: "index_session_rabbits_on_rabbit_id"
    t.index ["session_id"], name: "index_session_rabbits_on_session_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "uuid", null: false
    t.integer "status", default: 0
    t.boolean "colored_hint", default: false
    t.integer "hint_count", default: 0
    t.bigint "last_rabbit_talked_id"
    t.datetime "finished_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "language", default: 0
    t.boolean "is_connected", default: false
    t.string "api_key", null: false
    t.index ["last_rabbit_talked_id"], name: "index_sessions_on_last_rabbit_talked_id"
  end

  create_table "speech_branches", force: :cascade do |t|
    t.bigint "current_speech_id", null: false
    t.bigint "follow_speech_id", null: false
    t.string "answer", default: "next"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "speech_exited", default: false
    t.index ["current_speech_id"], name: "index_speech_branches_on_current_speech_id"
    t.index ["follow_speech_id"], name: "index_speech_branches_on_follow_speech_id"
  end

  create_table "speeches", force: :cascade do |t|
    t.string "text", null: false
    t.integer "speech_type", default: 0
    t.json "colored_words", default: {}
    t.bigint "rabbit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rabbit_id"], name: "index_speeches_on_rabbit_id"
  end

  add_foreign_key "session_rabbits", "rabbits"
  add_foreign_key "session_rabbits", "sessions"
  add_foreign_key "session_rabbits", "speeches", column: "current_speech_id"
  add_foreign_key "sessions", "rabbits", column: "last_rabbit_talked_id"
  add_foreign_key "speech_branches", "speeches", column: "current_speech_id"
  add_foreign_key "speech_branches", "speeches", column: "follow_speech_id"
  add_foreign_key "speeches", "rabbits"
end
