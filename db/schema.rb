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

ActiveRecord::Schema[7.1].define(version: 2025_04_12_235327) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "form_display_status", ["required", "optional", "hidden"]

  create_table "assignments", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "external_assignment_id"
    t.bigint "course_to_lms_id", null: false
    t.datetime "due_date"
    t.datetime "late_due_date"
    t.boolean "enabled", default: false
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
    t.string "canvas_id"
    t.string "course_code"
    t.index ["canvas_id"], name: "index_courses_on_canvas_id", unique: true
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

  create_table "form_settings", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.text "reason_desc"
    t.text "documentation_desc"
    t.enum "documentation_disp", enum_type: "form_display_status"
    t.string "custom_q1"
    t.text "custom_q1_desc"
    t.enum "custom_q1_disp", enum_type: "form_display_status"
    t.string "custom_q2"
    t.text "custom_q2_desc"
    t.enum "custom_q2_disp", enum_type: "form_display_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_form_settings_on_course_id"
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
    t.datetime "expire_time"
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
    t.string "canvas_uid"
    t.string "canvas_token"
    t.string "name"
    t.string "student_id"
    t.index ["canvas_uid"], name: "index_users_on_canvas_uid", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "assignments", "course_to_lmss"
  add_foreign_key "course_to_lmss", "courses"
  add_foreign_key "course_to_lmss", "lmss"
  add_foreign_key "extensions", "assignments"
  add_foreign_key "extensions", "users", column: "last_processed_by_id"
  add_foreign_key "form_settings", "courses"
  add_foreign_key "lms_credentials", "users"
  add_foreign_key "user_to_courses", "courses"
  add_foreign_key "user_to_courses", "users"
end
