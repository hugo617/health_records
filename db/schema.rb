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

ActiveRecord::Schema[7.2].define(version: 202511053) do
  create_table "entity_param_rels", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "rel_type", null: false
    t.bigint "entity_id", null: false
    t.bigint "param_id", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "rel_status", default: 1, null: false
    t.index ["param_id"], name: "index_entity_param_rels_on_param_id"
    t.index ["rel_type", "entity_id", "param_id"], name: "index_entity_param_rels_on_rel_type_entity_id_param_id", unique: true
  end

  create_table "files", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "file_name", null: false
    t.string "file_path", null: false
    t.bigint "file_size", null: false
    t.datetime "upload_time", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.integer "file_status", default: 1, null: false
    t.index ["user_id"], name: "index_files_on_user_id"
  end

  create_table "params", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "param_type", null: false
    t.string "param_name", null: false
    t.string "param_code", null: false
    t.text "param_desc"
    t.integer "sort", default: 0, null: false
    t.index ["param_code"], name: "index_params_on_param_code", unique: true
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "username", null: false
    t.string "nickname", null: false
    t.string "phone", null: false
    t.string "password", null: false
    t.datetime "create_time", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.integer "status", default: 1, null: false
    t.index ["nickname"], name: "index_users_on_nickname", unique: true
  end

  add_foreign_key "entity_param_rels", "params", on_delete: :cascade
  add_foreign_key "files", "users", on_delete: :cascade
end
