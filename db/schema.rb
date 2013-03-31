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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130331150748) do

  create_table "conversations", :force => true do |t|
    t.integer  "sender_id"
    t.string   "text"
    t.datetime "date"
    t.integer  "measurement_id", :null => false
  end

  add_index "conversations", ["measurement_id"], :name => "index_conversations_on_measurement_id"
  add_index "conversations", ["sender_id"], :name => "index_conversations_on_sender_id"

  create_table "exercise_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "exercises", :force => true do |t|
    t.integer  "training_id",      :null => false
    t.integer  "exercise_type_id", :null => false
    t.integer  "order"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "exercises", ["exercise_type_id"], :name => "index_exercises_on_exercise_type_id"
  add_index "exercises", ["training_id"], :name => "index_exercises_on_training_id"

  create_table "i18n_keys", :force => true do |t|
    t.string   "key"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "i18n_keys", ["key"], :name => "index_i18n_keys_on_key", :unique => true

  create_table "i18n_strings", :force => true do |t|
    t.integer  "i18n_key_id"
    t.string   "locale"
    t.text     "data"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "i18n_strings", ["i18n_key_id"], :name => "index_i18n_strings_on_i18n_key_id"
  add_index "i18n_strings", ["locale"], :name => "index_i18n_strings_on_locale"

  create_table "measurement_comments", :force => true do |t|
    t.integer "timestamp"
    t.string  "comment"
    t.integer "series_execution_id"
  end

  add_index "measurement_comments", ["series_execution_id"], :name => "index_measurement_comments_on_series_execution_id"

  create_table "measurements", :force => true do |t|
    t.integer  "trainee_id",                      :null => false
    t.integer  "trainer_id",                      :null => false
    t.integer  "training_id",                     :null => false
    t.binary   "data"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "rating"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.boolean  "trainer_seen", :default => false, :null => false
  end

  add_index "measurements", ["trainee_id"], :name => "index_measurements_on_trainee_id"
  add_index "measurements", ["trainer_id"], :name => "index_measurements_on_trainer_id"
  add_index "measurements", ["training_id"], :name => "index_measurements_on_training_id"

  create_table "newsletter_subscriptions", :force => true do |t|
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "series", :force => true do |t|
    t.integer  "exercise_id",                 :null => false
    t.integer  "order"
    t.integer  "repeat_count"
    t.integer  "weight"
    t.integer  "rest_time",    :default => 0, :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "series", ["exercise_id"], :name => "index_series_on_exercise_id"

  create_table "series_executions", :force => true do |t|
    t.integer "start_timestamp"
    t.integer "end_timestamp"
    t.integer "exercise_type_id",                :null => false
    t.integer "num_repetitions"
    t.integer "weight"
    t.integer "rest_time"
    t.integer "measurement_id",                  :null => false
    t.integer "duration_seconds", :default => 0
  end

  add_index "series_executions", ["exercise_type_id"], :name => "index_series_executions_on_exercise_type_id"
  add_index "series_executions", ["measurement_id"], :name => "index_series_executions_on_measurement_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "trainings", :force => true do |t|
    t.integer  "trainee_id"
    t.string   "name"
    t.integer  "original_training_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "trainings", ["original_training_id"], :name => "index_trainings_on_original_training_id"
  add_index "trainings", ["trainee_id"], :name => "index_trainings_on_trainee_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "full_name"
    t.integer  "role"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "is_trainer",             :default => false, :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  add_foreign_key "conversations", "measurements", :name => "conversations_measurement_id_fk", :dependent => :delete
  add_foreign_key "conversations", "users", :name => "conversations_sender_id_fk", :column => "sender_id", :dependent => :delete

  add_foreign_key "exercises", "exercise_types", :name => "exercises_exercise_type_id_fk", :dependent => :delete
  add_foreign_key "exercises", "trainings", :name => "exercises_training_id_fk", :dependent => :delete

  add_foreign_key "i18n_strings", "i18n_keys", :name => "i18n_strings_i18n_key_id_fk", :dependent => :delete

  add_foreign_key "measurement_comments", "series_executions", :name => "measurement_comments_series_execution_id_fk", :dependent => :delete

  add_foreign_key "measurements", "trainings", :name => "measurements_training_id_fk", :dependent => :delete
  add_foreign_key "measurements", "users", :name => "measurements_trainee_id_fk", :column => "trainee_id", :dependent => :delete
  add_foreign_key "measurements", "users", :name => "measurements_trainer_id_fk", :column => "trainer_id", :dependent => :nullify

  add_foreign_key "series", "exercises", :name => "series_exercise_id_fk", :dependent => :delete

  add_foreign_key "series_executions", "exercise_types", :name => "series_executions_exercise_type_id_fk", :dependent => :delete
  add_foreign_key "series_executions", "measurements", :name => "series_executions_measurement_id_fk", :dependent => :delete

  add_foreign_key "trainings", "trainings", :name => "trainings_original_training_id_fk", :column => "original_training_id", :dependent => :nullify
  add_foreign_key "trainings", "users", :name => "trainings_trainee_id_fk", :column => "trainee_id", :dependent => :delete

end
