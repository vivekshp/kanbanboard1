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

ActiveRecord::Schema[8.0].define(version: 2025_09_16_051118) do
  create_table "board_members", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "board_id", null: false
    t.bigint "user_id", null: false
    t.integer "role", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.index ["board_id"], name: "index_board_members_on_board_id"
    t.index ["user_id"], name: "index_board_members_on_user_id"
  end

  create_table "boards", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_boards_on_user_id"
  end

  create_table "histories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.string "action", null: false
    t.bigint "modified_by"
    t.datetime "time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "modified_to"
  end

  create_table "lists", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.integer "limit"
    t.integer "position"
    t.bigint "board_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["board_id"], name: "index_lists_on_board_id"
  end

  create_table "search_indices", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "task_id"
    t.bigint "board_id"
    t.bigint "assignee_id"
    t.integer "status"
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assignee_id"], name: "index_search_indices_on_assignee_id"
    t.index ["board_id"], name: "index_search_indices_on_board_id"
    t.index ["content"], name: "index_search_indices_on_content", type: :fulltext
    t.index ["record_type", "record_id"], name: "index_search_indices_on_record_type_and_record_id", unique: true
    t.index ["status"], name: "index_search_indices_on_status"
    t.index ["task_id"], name: "index_search_indices_on_task_id"
  end

  create_table "task_assignments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "task_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "assigned_by_id", null: false
    t.index ["assigned_by_id"], name: "fk_rails_ca3ffd900d"
    t.index ["task_id"], name: "index_task_assignments_on_task_id"
    t.index ["user_id"], name: "index_task_assignments_on_user_id"
  end

  create_table "tasks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "list_id", null: false
    t.string "title"
    t.text "description"
    t.integer "position"
    t.datetime "due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["list_id"], name: "index_tasks_on_list_id"
  end

  create_table "tenants", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "domain"
    t.string "db_name"
    t.json "db_config"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "board_members", "boards"
  add_foreign_key "board_members", "users"
  add_foreign_key "boards", "users"
  add_foreign_key "lists", "boards"
  add_foreign_key "task_assignments", "tasks"
  add_foreign_key "task_assignments", "users"
  add_foreign_key "task_assignments", "users", column: "assigned_by_id"
  add_foreign_key "tasks", "lists"
end
