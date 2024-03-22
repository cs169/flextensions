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

ActiveRecord::Schema[7.1].define(version: 2024_03_14_230145) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignments", force: :cascade do |t|
    t.bigint "platform_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["platform_id"], name: "index_assignments_on_platform_id"
  end

  create_table "course_to_platforms", force: :cascade do |t|
    t.bigint "platform_id"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_course_to_platforms_on_course_id"
    t.index ["platform_id"], name: "index_course_to_platforms_on_platform_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "course_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "extensions", force: :cascade do |t|
    t.bigint "assignment_id"
    t.string "student_email"
    t.datetime "initial_due_date"
    t.datetime "new_due_date"
    t.bigint "last_processed_by_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assignment_id"], name: "index_extensions_on_assignment_id"
  end

  create_table "platform_credentials", force: :cascade do |t|
    t.bigint "user_id"
    t.string "platform_name"
    t.string "username"
    t.string "password"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_platform_credentials_on_user_id"
  end

  create_table "platforms", force: :cascade do |t|
    t.string "platform_name"
    t.boolean "use_auth_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_to_courses", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "course_id"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_user_to_courses_on_course_id"
    t.index ["user_id"], name: "index_user_to_courses_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "assignments", "platforms"
  add_foreign_key "course_to_platforms", "courses"
  add_foreign_key "course_to_platforms", "platforms"
  add_foreign_key "extensions", "assignments"
  add_foreign_key "platform_credentials", "users"
  add_foreign_key "user_to_courses", "courses"
  add_foreign_key "user_to_courses", "users"
end
