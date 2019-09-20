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

ActiveRecord::Schema.define(version: 2019_09_19_165216) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "gns_core_roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "creator_id"
    t.boolean "active", default: true
    t.index ["creator_id"], name: "index_gns_core_roles_on_creator_id"
  end

  create_table "gns_core_roles_permissions", force: :cascade do |t|
    t.bigint "role_id"
    t.string "permission"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_gns_core_roles_permissions_on_role_id"
  end

  create_table "gns_core_roles_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_gns_core_roles_users_on_role_id"
    t.index ["user_id"], name: "index_gns_core_roles_users_on_user_id"
  end

  create_table "gns_core_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "cache_search"
    t.string "avatar"
    t.bigint "creator_id"
    t.index ["creator_id"], name: "index_gns_core_users_on_creator_id"
    t.index ["email"], name: "index_gns_core_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_gns_core_users_on_reset_password_token", unique: true
  end

  create_table "gns_etl_logs", force: :cascade do |t|
    t.datetime "logtime"
    t.integer "stage"
    t.string "message"
    t.string "trace_data"
    t.boolean "success"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "gns_etl_mappings", force: :cascade do |t|
    t.string "source_table"
    t.string "source_field"
    t.string "source_data_format"
    t.string "target_table"
    t.string "target_field"
    t.string "target_data_format"
    t.string "default_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "gns_etl_schedules", force: :cascade do |t|
    t.string "name"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "comment"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "gns_etl_transfer_values", force: :cascade do |t|
    t.integer "schedule_id"
    t.integer "mapping_id"
    t.integer "reference_id"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
