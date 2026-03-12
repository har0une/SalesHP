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

ActiveRecord::Schema[8.1].define(version: 2026_03_11_112411) do
  create_table "goals", force: :cascade do |t|
    t.boolean "active"
    t.datetime "created_at", null: false
    t.date "deadline"
    t.date "start_date"
    t.decimal "target_amount"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_goals_on_user_id"
  end

  create_table "sales_entries", force: :cascade do |t|
    t.decimal "amount", precision: 15, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "entry_date", default: -> { "CURRENT_TIMESTAMP" }
    t.integer "goal_id", null: false
    t.string "method"
    t.integer "status", default: 0
    t.datetime "updated_at", null: false
    t.integer "xp_earned", default: 0
    t.index ["goal_id"], name: "index_sales_entries_on_goal_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "current_streak"
    t.string "email"
    t.string "industry"
    t.string "rank"
    t.integer "total_xp"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "goals", "users"
  add_foreign_key "sales_entries", "goals"
end
