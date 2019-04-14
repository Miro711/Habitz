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

ActiveRecord::Schema.define(version: 2019_04_06_221743) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "habits", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.text "description"
    t.string "habit_type"
    t.float "threshold"
    t.string "unit"
    t.string "min_or_max"
    t.integer "target_streak"
    t.boolean "is_public", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_habits_on_user_id"
  end

  create_table "tackled_habits", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "habit_id"
    t.json "checkins", default: []
    t.boolean "is_reminder", default: false
    t.integer "current_streak"
    t.integer "wins"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["habit_id"], name: "index_tackled_habits_on_habit_id"
    t.index ["user_id"], name: "index_tackled_habits_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.boolean "is_admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "habits", "users"
  add_foreign_key "tackled_habits", "habits"
  add_foreign_key "tackled_habits", "users"
end
