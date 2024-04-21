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

ActiveRecord::Schema[7.1].define(version: 2024_04_20_232708) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignments", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "external_assignment_id"
    t.bigint "course_to_lms_id", null: false
  end

  create_table "course_to_lmss", force: :cascade do |t|
    t.bigint "lms_id"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "external_course_id"
    t.index ["course_id"], name: "index_course_to_lmss_on_course_id"
    t.index ["lms_id"], name: "index_course_to_lmss_on_lms_id"
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
    t.bigint "last_processed_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "external_extension_id"
    t.index ["assignment_id"], name: "index_extensions_on_assignment_id"
    t.index ["last_processed_by_id"], name: "index_extensions_on_last_processed_by_id"
  end

  create_table "lms_credentials", force: :cascade do |t|
    t.bigint "user_id"
    t.string "lms_name"
    t.string "username"
    t.string "password"
    t.string "token"
    t.string "refresh_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "external_user_id"
    t.index ["user_id"], name: "index_lms_credentials_on_user_id"
  end

  create_table "lmss", force: :cascade do |t|
    t.string "lms_name"
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

  add_foreign_key "assignments", "course_to_lmss"
  add_foreign_key "course_to_lmss", "courses"
  add_foreign_key "course_to_lmss", "lmss"
  add_foreign_key "extensions", "assignments"
  add_foreign_key "extensions", "users", column: "last_processed_by_id"
  add_foreign_key "lms_credentials", "users"
  add_foreign_key "user_to_courses", "courses"
  add_foreign_key "user_to_courses", "users"
end
