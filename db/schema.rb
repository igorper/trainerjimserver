# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150125185326) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "conversations", force: :cascade do |t|
    t.integer  "sender_id"
    t.string   "text",           limit: 255
    t.datetime "date"
    t.integer  "measurement_id",             null: false
  end

  add_index "conversations", ["measurement_id"], name: "index_conversations_on_measurement_id", using: :btree
  add_index "conversations", ["sender_id"], name: "index_conversations_on_sender_id", using: :btree

  create_table "exercise_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exercises", force: :cascade do |t|
    t.integer  "training_id",                                               null: false
    t.integer  "exercise_type_id",                                          null: false
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "machine_setting",            limit: 255
    t.decimal  "duration_after_repetition"
    t.decimal  "duration_up_repetition"
    t.decimal  "duration_middle_repetition"
    t.decimal  "duration_down_repetition"
    t.string   "guidance_type",              limit: 255, default: "manual", null: false
  end

  add_index "exercises", ["exercise_type_id"], name: "index_exercises_on_exercise_type_id", using: :btree
  add_index "exercises", ["training_id"], name: "index_exercises_on_training_id", using: :btree

  create_table "i18n_keys", force: :cascade do |t|
    t.string   "key",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "i18n_keys", ["key"], name: "index_i18n_keys_on_key", unique: true, using: :btree

  create_table "i18n_strings", force: :cascade do |t|
    t.integer  "i18n_key_id"
    t.string   "locale",      limit: 255
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "i18n_strings", ["i18n_key_id"], name: "index_i18n_strings_on_i18n_key_id", using: :btree
  add_index "i18n_strings", ["locale"], name: "index_i18n_strings_on_locale", using: :btree

  create_table "measurement_comments", force: :cascade do |t|
    t.integer "timestamp"
    t.string  "comment",             limit: 255
    t.integer "series_execution_id"
  end

  add_index "measurement_comments", ["series_execution_id"], name: "index_measurement_comments_on_series_execution_id", using: :btree

  create_table "measurements", force: :cascade do |t|
    t.integer  "trainee_id",                               null: false
    t.integer  "trainer_id"
    t.integer  "training_id",                              null: false
    t.binary   "data"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "trainer_seen",             default: false, null: false
    t.string   "comment",      limit: 255
  end

  add_index "measurements", ["trainee_id"], name: "index_measurements_on_trainee_id", using: :btree
  add_index "measurements", ["trainer_id"], name: "index_measurements_on_trainer_id", using: :btree
  add_index "measurements", ["training_id"], name: "index_measurements_on_training_id", using: :btree

  create_table "newsletter_subscriptions", force: :cascade do |t|
    t.string   "email",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "newsletter_subscriptions", ["email"], name: "index_newsletter_subscriptions_on_email", unique: true, using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name"], name: "index_roles_on_name", unique: true, using: :btree

  create_table "roles_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "roles_users", ["role_id"], name: "index_roles_users_on_role_id", using: :btree
  add_index "roles_users", ["user_id"], name: "index_roles_users_on_user_id", using: :btree

  create_table "series", force: :cascade do |t|
    t.integer  "exercise_id",              null: false
    t.integer  "order"
    t.integer  "repeat_count"
    t.integer  "weight"
    t.integer  "rest_time",    default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "series", ["exercise_id"], name: "index_series_on_exercise_id", using: :btree

  create_table "series_executions", force: :cascade do |t|
    t.integer "start_timestamp"
    t.integer "end_timestamp"
    t.integer "num_repetitions"
    t.integer "weight"
    t.integer "rest_time"
    t.integer "measurement_id",               null: false
    t.integer "duration_seconds", default: 0
    t.integer "rating"
    t.integer "parent_series_id",             null: false
  end

  add_index "series_executions", ["measurement_id"], name: "index_series_executions_on_measurement_id", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255, null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "trainings", force: :cascade do |t|
    t.integer  "trainee_id"
    t.string   "name",                 limit: 255
    t.integer  "original_training_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trainings", ["original_training_id"], name: "index_trainings_on_original_training_id", using: :btree
  add_index "trainings", ["trainee_id"], name: "index_trainings_on_trainee_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255
    t.string   "full_name",              limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.integer  "trainer_id"
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["trainer_id"], name: "index_users_on_trainer_id", using: :btree

  add_foreign_key "conversations", "measurements", name: "conversations_measurement_id_fk", on_update: :cascade, on_delete: :cascade
  add_foreign_key "conversations", "users", column: "sender_id", name: "conversations_sender_id_fk", on_update: :cascade, on_delete: :cascade
  add_foreign_key "exercises", "exercise_types", name: "exercises_exercise_type_id_fk", on_update: :cascade, on_delete: :cascade
  add_foreign_key "exercises", "trainings", name: "exercises_training_id_fk", on_update: :cascade, on_delete: :cascade
  add_foreign_key "i18n_strings", "i18n_keys", name: "i18n_strings_i18n_key_id_fk", on_update: :cascade, on_delete: :cascade
  add_foreign_key "measurement_comments", "series_executions", name: "measurement_comments_series_execution_id_fk", on_update: :cascade, on_delete: :cascade
  add_foreign_key "measurements", "trainings", name: "measurements_training_id_fk", on_update: :cascade, on_delete: :cascade
  add_foreign_key "measurements", "users", column: "trainee_id", name: "measurements_trainee_id_fk", on_update: :cascade, on_delete: :cascade
  add_foreign_key "measurements", "users", column: "trainer_id", name: "measurements_trainer_id_fk", on_update: :cascade, on_delete: :nullify
  add_foreign_key "roles_users", "roles", name: "roles_users_role_id_fk", on_update: :cascade, on_delete: :cascade
  add_foreign_key "roles_users", "users", name: "roles_users_user_id_fk", on_update: :cascade, on_delete: :cascade
  add_foreign_key "series", "exercises", name: "series_exercise_id_fk", on_update: :cascade, on_delete: :cascade
  add_foreign_key "series_executions", "measurements", name: "series_executions_measurement_id_fk", on_update: :cascade, on_delete: :cascade
  add_foreign_key "series_executions", "series", column: "parent_series_id", on_update: :cascade
  add_foreign_key "trainings", "trainings", column: "original_training_id", name: "trainings_original_training_id_fk", on_update: :cascade, on_delete: :nullify
  add_foreign_key "trainings", "users", column: "trainee_id", name: "trainings_trainee_id_fk", on_update: :cascade, on_delete: :cascade
  add_foreign_key "users", "users", column: "trainer_id", name: "users_trainer_id_fk", on_update: :cascade, on_delete: :nullify
end
