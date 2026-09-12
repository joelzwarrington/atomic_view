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

ActiveRecord::Schema[8.1].define(version: 2026_01_01_000002) do
  create_table "bookings", force: :cascade do |t|
    t.string "camper_name", null: false
    t.datetime "created_at", null: false
    t.date "ends_on", null: false
    t.integer "site_id", null: false
    t.date "starts_on", null: false
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.index ["site_id"], name: "index_bookings_on_site_id"
    t.index ["starts_on", "ends_on"], name: "index_bookings_on_starts_on_and_ends_on"
  end

  create_table "sites", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.string "park_name", null: false
    t.datetime "updated_at", null: false
    t.index ["code", "id"], name: "index_sites_on_code_and_id", unique: true
  end

  add_foreign_key "bookings", "sites"
end
