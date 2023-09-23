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

ActiveRecord::Schema[7.0].define(version: 2023_09_23_091201) do
  create_table "clients", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "display_name"
    t.string "logo"
    t.string "logo_2x"
    t.string "access_key", null: false
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hotels", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "company"
    t.string "location"
    t.string "hlx_hotel_id"
    t.string "hlx_username"
    t.string "hlx_consumer_key"
    t.string "hlx_consumer_secret"
    t.string "hlx_counter_id"
    t.string "hlx_counter_name"
    t.string "hlx_counter_email"
    t.string "hlx_counter_pwd"
    t.string "hlx_access_key"
    t.string "hlx_access_secret"
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id"
    t.index ["client_id"], name: "index_hotels_on_client_id"
  end

  create_table "room_types", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "hlx_room_type_id"
    t.string "hlx_room_type_name"
    t.integer "max_occupancy"
    t.boolean "is_split_allowed", default: false
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id"
    t.index ["client_id"], name: "index_room_types_on_client_id"
  end

  create_table "rooms", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "room_name"
    t.bigint "room_type_id", null: false
    t.bigint "hotel_id", null: false
    t.string "hlx_hotel_id"
    t.string "hlx_room_id"
    t.string "hlx_room_name"
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "hlx_room_type_id"
    t.string "hlx_room_type_name"
    t.index ["hotel_id"], name: "index_rooms_on_hotel_id"
    t.index ["room_type_id"], name: "index_rooms_on_room_type_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "username", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "hotels", "clients"
  add_foreign_key "room_types", "clients"
  add_foreign_key "rooms", "hotels"
  add_foreign_key "rooms", "room_types"
end
