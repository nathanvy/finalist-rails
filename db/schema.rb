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

ActiveRecord::Schema[8.1].define(version: 2025_12_30_221423) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "pg_catalog.plpgsql"

  create_table "items", force: :cascade do |t|
    t.text "body", null: false
    t.boolean "completed"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.bigint "created_by_id"
    t.bigint "list_id", null: false
    t.integer "position"
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_items_on_created_by_id"
    t.index ["list_id"], name: "index_items_on_list_id"
  end

  create_table "list_memberships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "list_id", null: false
    t.integer "role", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["list_id", "user_id"], name: "index_list_memberships_on_list_id_and_user_id", unique: true
    t.index ["list_id"], name: "index_list_memberships_on_list_id"
    t.index ["user_id"], name: "index_list_memberships_on_user_id"
  end

  create_table "lists", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "owner_id", null: false
    t.text "title", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_lists_on_owner_id"
  end

  create_table "signup_tokens", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "created_by_user_id", null: false
    t.datetime "expires_at"
    t.string "label"
    t.integer "max_uses", default: 1, null: false
    t.datetime "revoked_at"
    t.string "token_digest", null: false
    t.datetime "updated_at", null: false
    t.integer "uses_count", default: 0, null: false
    t.index ["created_by_user_id"], name: "index_signup_tokens_on_created_by_user_id"
    t.index ["token_digest"], name: "index_signup_tokens_on_token_digest", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "disabled_at"
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.citext "username", null: false
    t.index ["admin"], name: "index_users_on_admin"
    t.index ["disabled_at"], name: "index_users_on_disabled_at"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "items", "lists"
  add_foreign_key "items", "users", column: "created_by_id"
  add_foreign_key "list_memberships", "lists"
  add_foreign_key "list_memberships", "users"
  add_foreign_key "lists", "users", column: "owner_id"
  add_foreign_key "signup_tokens", "users", column: "created_by_user_id"
end
