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

ActiveRecord::Schema.define(version: 2023_04_19_093828) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bill_lists", force: :cascade do |t|
    t.boolean "is_pay"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "unit_price"
    t.string "list_typeName"
  end

  create_table "bills", force: :cascade do |t|
    t.bigint "room_id"
    t.bigint "rent_id"
    t.bigint "bill_list_id"
    t.date "bill_date"
    t.string "bill_no"
    t.float "bill_total"
    t.string "bill_remark"
    t.integer "old_unit"
    t.integer "new_unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bill_list_id"], name: "index_bills_on_bill_list_id"
    t.index ["rent_id"], name: "index_bills_on_rent_id"
    t.index ["room_id"], name: "index_bills_on_room_id"
  end

  create_table "halls", force: :cascade do |t|
    t.string "hall_name"
    t.string "hall_address"
    t.string "hall_tel"
    t.string "hall_logo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rents", force: :cascade do |t|
    t.bigint "room_id"
    t.bigint "user_id"
    t.date "rent_start"
    t.date "rent_end"
    t.string "rent_history"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_rents_on_room_id"
    t.index ["user_id"], name: "index_rents_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.bigint "hall_id", null: false
    t.bigint "user_id"
    t.string "room_num"
    t.boolean "room_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hall_id"], name: "index_rooms_on_hall_id"
    t.index ["user_id"], name: "index_rooms_on_user_id"
  end

  create_table "statements", force: :cascade do |t|
    t.bigint "bill_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bill_id"], name: "index_statements_on_bill_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "user_fname"
    t.string "user_lname"
    t.string "user_address"
    t.integer "user_tel"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "bills", "bill_lists"
  add_foreign_key "bills", "rents"
  add_foreign_key "bills", "rooms"
  add_foreign_key "rents", "rooms"
  add_foreign_key "rents", "users"
  add_foreign_key "rooms", "halls"
  add_foreign_key "rooms", "users"
  add_foreign_key "statements", "bills"
end
