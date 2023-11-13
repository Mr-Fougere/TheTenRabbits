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

ActiveRecord::Schema[7.1].define(version: 2023_11_13_200442) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "rabbits", force: :cascade do |t|
    t.string "name", null: false
    t.integer "color", null: false
    t.string "hint_text", null: false
    t.json "colored_hint_words", default: []
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
    t.index ["rabbit_id"], name: "index_session_rabbits_on_rabbit_id"
    t.index ["session_id"], name: "index_session_rabbits_on_session_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "uuid", null: false
    t.integer "status", default: 0
    t.boolean "with_colored_hint", default: false
    t.bigint "hinted_rabbit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "language", default: 0
    t.index ["hinted_rabbit_id"], name: "index_sessions_on_hinted_rabbit_id"
  end

  add_foreign_key "session_rabbits", "rabbits"
  add_foreign_key "session_rabbits", "sessions"
  add_foreign_key "sessions", "rabbits", column: "hinted_rabbit_id"
end
