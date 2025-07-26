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

ActiveRecord::Schema[7.2].define(version: 2025_06_30_225309) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agatha_emails", force: :cascade do |t|
    t.string "from_email", default: ""
    t.string "to_email", default: ""
    t.string "subject", default: ""
    t.text "body", default: ""
    t.string "attachments", default: ""
    t.boolean "sent", default: false
    t.integer "email_template_id", default: 1
    t.integer "person_id", default: 1
    t.integer "term_id", default: 1
    t.integer "course_id", default: 1
    t.string "attached_files"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["person_id"], name: "index_agatha_emails_on_person_id"
    t.index ["term_id"], name: "index_agatha_emails_on_term_id"
  end

  create_table "agatha_files", force: :cascade do |t|
    t.integer "person_id", default: 1
    t.integer "course_id", default: 1
    t.text "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "agatha_data_file_name"
    t.string "agatha_data_content_type"
    t.integer "agatha_data_file_size"
    t.datetime "agatha_data_updated_at"
  end

  create_table "attendee_csvs", force: :cascade do |t|
    t.integer "student"
    t.integer "lectures_course"
    t.boolean "compulsory"
    t.boolean "examined"
    t.string "mark"
  end

  create_table "attendees", force: :cascade do |t|
    t.integer "lecture_id", default: 1, null: false
    t.integer "person_id", default: 1, null: false
    t.boolean "examined", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "compulsory"
    t.string "mark"
    t.string "mark_type"
    t.text "comment"
    t.index ["lecture_id", "person_id"], name: "unique_attendees", unique: true
    t.index ["lecture_id"], name: "index_attendees_on_lecture_id"
    t.index ["person_id"], name: "index_attendees_on_person_id"
  end

  create_table "course_csvs", force: :cascade do |t|
    t.string "course_name"
    t.string "paper_number"
    t.boolean "studium_course"
    t.boolean "evening_course"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "day_csvs", force: :cascade do |t|
    t.string "long_name"
    t.string "short_name"
  end

  create_table "days", force: :cascade do |t|
    t.string "long_name"
    t.string "short_name"
    t.boolean "sunday"
    t.boolean "monday"
    t.boolean "tuesday"
    t.boolean "wednesday"
    t.boolean "thursday"
    t.boolean "friday"
    t.boolean "saturday"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "display_filters", force: :cascade do |t|
    t.integer "user_id", default: 1
    t.string "table_name"
    t.integer "filter_index"
    t.integer "element_order"
    t.boolean "in_use"
    t.index ["user_id"], name: "index_display_filters_on_user_id"
  end

  create_table "email_attachments", force: :cascade do |t|
    t.integer "agatha_email_id"
    t.integer "agatha_file_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["agatha_email_id", "agatha_file_id"], name: "index_email_attachments_on_agatha_email_id_and_agatha_file_id"
  end

  create_table "email_templates", force: :cascade do |t|
    t.string "template_name", default: ""
    t.string "from_email", default: ""
    t.string "subject", default: ""
    t.text "ruby_header", default: ""
    t.text "body", default: ""
    t.integer "attachment_rule_id", default: 1
    t.string "attachment_file_list", default: ""
    t.boolean "term_dependency", default: true
    t.boolean "course_dependency", default: false
    t.text "global_warnings", default: ""
    t.text "personal_warnings", default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "external_filter_values", force: :cascade do |t|
    t.integer "user_id", default: 1
    t.string "table_name"
    t.integer "filter_id", default: 1
    t.integer "member_id", default: 1
    t.integer "group_id", default: 1
    t.boolean "in_use"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_external_filter_values_on_user_id"
  end

  create_table "format_elements", force: :cascade do |t|
    t.integer "user_id", default: 1
    t.string "table_name"
    t.string "field_name"
    t.string "insert_string"
    t.integer "element_order"
    t.boolean "in_use"
    t.index ["user_id"], name: "index_format_elements_on_user_id"
  end

  create_table "group_agatha_emails", force: :cascade do |t|
    t.integer "group_id"
    t.integer "agatha_email_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_attendees", force: :cascade do |t|
    t.integer "group_id", default: 1
    t.integer "attendee_id", default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["attendee_id", "group_id"], name: "unique_group_attendees", unique: true
  end

  create_table "group_courses", force: :cascade do |t|
    t.integer "group_id", default: 1
    t.integer "course_id", default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["course_id", "group_id"], name: "unique_group_courses", unique: true
  end

  create_table "group_days", force: :cascade do |t|
    t.integer "group_id", default: 1
    t.integer "day_id", default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["day_id", "group_id"], name: "unique_group_days", unique: true
  end

  create_table "group_email_templates", force: :cascade do |t|
    t.integer "group_id"
    t.integer "email_template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_filters", force: :cascade do |t|
    t.integer "user_id", default: 1
    t.string "table_name"
    t.text "foreign_key"
    t.integer "group_id", default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_group_filters_on_user_id"
  end

  create_table "group_institutions", force: :cascade do |t|
    t.integer "group_id", default: 1
    t.integer "institution_id", default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["group_id", "institution_id"], name: "unique_group_institutions", unique: true
  end

  create_table "group_lectures", force: :cascade do |t|
    t.integer "group_id", default: 1
    t.integer "lecture_id", default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["group_id", "lecture_id"], name: "unique_group_lectures", unique: true
  end

  create_table "group_locations", force: :cascade do |t|
    t.integer "group_id", default: 1
    t.integer "location_id", default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["group_id", "location_id"], name: "unique_group_locations", unique: true
  end

  create_table "group_people", force: :cascade do |t|
    t.integer "group_id", default: 1
    t.integer "person_id", default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["group_id", "person_id"], name: "unique_group_people", unique: true
  end

  create_table "group_programmes", force: :cascade do |t|
    t.integer "group_id"
    t.integer "programme_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["group_id", "programme_id"], name: "unique_group_programmes", unique: true
  end

  create_table "group_term_names", force: :cascade do |t|
    t.integer "group_id", default: 1
    t.integer "term_name_id", default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["group_id", "term_name_id"], name: "unique_group_term_names", unique: true
  end

  create_table "group_terms", force: :cascade do |t|
    t.integer "group_id", default: 1
    t.integer "term_id", default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["group_id", "term_id"], name: "unique_group_terms", unique: true
  end

  create_table "group_tutorial_schedules", force: :cascade do |t|
    t.integer "group_id", default: 1
    t.integer "tutorial_schedule_id", default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["group_id", "tutorial_schedule_id"], name: "unique_group_tutorial_schedules", unique: true
  end

  create_table "group_tutorials", force: :cascade do |t|
    t.integer "group_id", default: 1
    t.integer "tutorial_id", default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["group_id", "tutorial_id"], name: "unique_group_tutorials", unique: true
  end

  create_table "group_users", force: :cascade do |t|
    t.integer "group_id", default: 1
    t.integer "user_id", default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["group_id", "user_id"], name: "unique_group_users", unique: true
  end

  create_table "group_willing_lecturers", force: :cascade do |t|
    t.integer "group_id"
    t.integer "willing_lecturer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_willing_tutors", force: :cascade do |t|
    t.integer "group_id"
    t.integer "willing_tutor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: :cascade do |t|
    t.string "group_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "table_name"
    t.integer "owner_id", default: 1
    t.boolean "private"
    t.integer "readers_id", default: 1
    t.integer "writers_id", default: 1
    t.index ["group_name", "table_name"], name: "unique_groups", unique: true
  end

  create_table "institutions", force: :cascade do |t|
    t.string "old_name"
    t.string "title"
    t.string "first_name"
    t.string "second_name"
    t.string "salutation"
    t.string "term_address"
    t.string "term_city"
    t.string "term_postcode"
    t.string "conventual_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lecture_csvs", force: :cascade do |t|
    t.integer "term"
    t.integer "course"
    t.integer "tutor"
    t.integer "number_of_lectures"
    t.integer "number_of_classes"
    t.integer "hours"
    t.text "notes"
    t.string "examination"
    t.integer "day"
    t.datetime "lecture_time"
    t.string "week"
  end

  create_table "lectures", force: :cascade do |t|
    t.integer "course_id", default: 1, null: false
    t.integer "person_id", default: 1, null: false
    t.integer "term_id", default: 1
    t.string "exam"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "day_id"
    t.time "lecture_time"
    t.integer "location_id", default: 1
    t.integer "number_of_classes", default: 0
    t.integer "number_of_lectures", default: 0
    t.integer "hours", default: 0
    t.text "notes"
    t.index ["course_id"], name: "index_lectures_on_course_id"
    t.index ["day_id"], name: "index_lectures_on_day_id"
    t.index ["person_id"], name: "index_lectures_on_person_id"
    t.index ["term_id"], name: "index_lectures_on_term_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.integer "max_people"
  end

  create_table "maximum_tutorials", force: :cascade do |t|
    t.integer "person_id"
    t.integer "max_tutorials"
    t.integer "term_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["person_id"], name: "index_maximum_tutorials_on_person_id"
    t.index ["term_id"], name: "index_maximum_tutorials_on_term_id"
  end

  create_table "open_records", force: :cascade do |t|
    t.integer "user_id", default: 1
    t.string "table_name"
    t.integer "record_id", default: 1
    t.boolean "in_use"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_open_records_on_user_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "title"
    t.string "first_name"
    t.string "second_name"
    t.string "postnomials"
    t.string "salutation"
    t.string "term_address"
    t.string "term_city"
    t.string "term_postcode"
    t.string "term_home_phone"
    t.string "term_work_phone"
    t.string "mobile"
    t.string "email"
    t.string "other_address"
    t.string "other_city"
    t.string "other_postcode"
    t.string "other_home_phone"
    t.string "fax"
    t.text "notes"
    t.integer "entry_term_id", default: 1, null: false
    t.string "next_of_kin"
    t.string "conventual_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "institution_id", default: 1
    t.integer "religious_house_id", default: 1
    t.text "previous_studies"
    t.text "interests"
    t.boolean "html_email", default: true
    t.index ["first_name", "second_name"], name: "index_people_on_first_name_and_second_name"
  end

  create_table "person_csvs", force: :cascade do |t|
    t.string "old_name"
    t.string "title"
    t.string "first_name"
    t.string "second_name"
    t.string "postnominals"
    t.string "salutation"
    t.string "term_address"
    t.string "term_city"
    t.string "term_postcode"
    t.string "term_home_phone"
    t.string "term_work_phone"
    t.string "mobile"
    t.string "email"
    t.string "other_address"
    t.string "other_city"
    t.string "other_postcode"
    t.string "other_home_phone"
    t.string "Fax"
    t.text "Notes"
    t.integer "supervisor"
    t.integer "entry_year"
    t.integer "matriculated"
    t.boolean "senior_status"
    t.integer "programme"
    t.integer "religious_house"
    t.string "next_of_kin"
    t.integer "home_institution"
    t.string "conventual_name"
  end

  create_table "personstatus_csvs", force: :cascade do |t|
    t.integer "person_id"
    t.integer "status_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", default: "1", null: false
    t.text "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id"
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "status_csvs", force: :cascade do |t|
    t.string "status"
    t.boolean "student"
    t.boolean "tutor"
    t.integer "sort_key"
  end

  create_table "term_csvs", force: :cascade do |t|
    t.integer "name"
    t.datetime "startdate"
    t.integer "year"
  end

  create_table "term_names", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "terms", force: :cascade do |t|
    t.integer "term_name_id", default: 1
    t.integer "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["term_name_id"], name: "index_terms_on_term_name_id"
  end

  create_table "tutorial_csvs", force: :cascade do |t|
    t.integer "student"
    t.integer "term"
    t.integer "course"
    t.integer "tutor"
    t.integer "number"
    t.string "mark"
    t.integer "hours"
    t.text "notes"
  end

  create_table "tutorial_schedules", force: :cascade do |t|
    t.integer "person_id", default: 1
    t.integer "course_id", default: 1
    t.integer "term_id", default: 1
    t.integer "number_of_tutorials", default: 0
    t.integer "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "number_of_tutorial_hours", default: 0
    t.index ["course_id"], name: "index_tutorial_schedules_on_course_id"
    t.index ["person_id"], name: "index_tutorial_schedules_on_person_id"
    t.index ["term_id"], name: "index_tutorial_schedules_on_term_id"
  end

  create_table "tutorials", force: :cascade do |t|
    t.integer "person_id", default: 1
    t.integer "tutorial_schedule_id", default: 1
    t.text "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "notes"
    t.string "mark_type"
    t.string "mark"
    t.integer "collection_status"
    t.string "collection_mark"
    t.index ["person_id", "tutorial_schedule_id"], name: "unique_tutorials", unique: true
    t.index ["person_id"], name: "index_tutorials_on_person_id"
    t.index ["tutorial_schedule_id"], name: "index_tutorials_on_tutorial_schedule_id"
  end

  create_table "user_pages", force: :cascade do |t|
    t.integer "user_id", default: 1
    t.string "page_name", default: "Person"
    t.integer "option_id", default: 0
    t.boolean "is_active", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["page_name", "user_id"], name: "unique_page_names", unique: true
    t.index ["user_id"], name: "index_user_pages_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "hashed_password"
    t.string "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "person_id", default: 1
    t.index ["name"], name: "unique_users", unique: true
  end

  create_table "willing_lecturers", force: :cascade do |t|
    t.integer "person_id"
    t.integer "course_id"
    t.integer "order_of_preference"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["course_id"], name: "index_willing_lecturers_on_course_id"
    t.index ["person_id"], name: "index_willing_lecturers_on_person_id"
  end

  create_table "willing_teacher_csvs", force: :cascade do |t|
    t.integer "tutor"
    t.integer "course"
    t.text "notes"
  end

  create_table "willing_teachers", force: :cascade do |t|
    t.integer "person_id", default: 1
    t.integer "course_id", default: 1
    t.integer "order_of_preference"
    t.boolean "can_lecture"
    t.boolean "can_tutor"
    t.text "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "willing_tutors", force: :cascade do |t|
    t.integer "person_id"
    t.integer "course_id"
    t.integer "order_of_preference"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["course_id"], name: "index_willing_tutors_on_course_id"
    t.index ["person_id"], name: "index_willing_tutors_on_person_id"
  end
end
