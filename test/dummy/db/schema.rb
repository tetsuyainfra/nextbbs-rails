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

ActiveRecord::Schema.define(version: 2019_12_18_062615) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "nextbbs_boards", force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.text "description"
    t.string "hash_token"
    t.integer "status", limit: 2, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "comments_count", default: 0, null: false
    t.bigint "owner_id", null: false
  end

  create_table "nextbbs_comments", force: :cascade do |t|
    t.bigint "topic_id"
    t.string "name"
    t.string "email"
    t.text "body"
    t.string "hashid"
    t.inet "ip", null: false
    t.string "hostname"
    t.integer "status", limit: 2, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "owner_id"
    t.index ["topic_id"], name: "index_nextbbs_comments_on_topic_id"
  end

  create_table "nextbbs_topics", force: :cascade do |t|
    t.bigint "board_id"
    t.string "title"
    t.integer "status", limit: 2, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "comments_count", default: 0, null: false
    t.index ["board_id"], name: "index_nextbbs_topics_on_board_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "nextbbs_boards", "users", column: "owner_id"
  add_foreign_key "nextbbs_comments", "nextbbs_topics", column: "topic_id"
  add_foreign_key "nextbbs_topics", "nextbbs_boards", column: "board_id"
end
