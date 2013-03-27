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

ActiveRecord::Schema.define(:version => 20130327151809) do

  create_table "conversations", :force => true do |t|
    t.integer  "user1_id"
    t.integer  "user2_id"
    t.string   "text"
    t.integer  "measurement_id"
    t.datetime "date"
  end

  create_table "exercise_types", :force => true do |t|
    t.string "name"
  end

  create_table "exercises", :force => true do |t|
    t.integer  "training_id",      :null => false
    t.integer  "order"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "exercise_type_id"
  end

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
    t.integer "series_executions_id"
  end

  create_table "measurements", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.binary   "data"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "training_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "rating"
  end

  add_index "measurements", ["training_id"], :name => "index_measurements_on_training_id"
  add_index "measurements", ["user_id"], :name => "index_measurements_on_user_id"

  create_table "series", :force => true do |t|
    t.integer  "exercise_id",  :null => false
    t.integer  "order"
    t.integer  "repeat_count"
    t.integer  "weight"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "rest_time"
  end

  add_index "series", ["exercise_id"], :name => "index_series_on_exercise_id"

  create_table "series_events", :force => true do |t|
    t.integer  "measurement_id"
    t.integer  "event_type"
    t.datetime "timestamp"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "series_events", ["measurement_id"], :name => "index_series_events_on_measurement_id"

  create_table "series_executions", :force => true do |t|
    t.integer "start_timestamp"
    t.integer "end_timestamp"
    t.integer "exercise_id"
    t.integer "num_repetitions"
    t.integer "weight"
    t.integer "rest_time"
    t.integer "measurement_id"
    t.integer "duration_seconds", :default => 0
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "trainings", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "trainee_user_id"
  end

  add_index "trainings", ["trainee_user_id"], :name => "index_trainings_on_trainee_user_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.integer  "role"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "full_name"
    t.integer  "trainer_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

  add_foreign_key "conversations", "measurements", :name => "conversations_measurement_id_fk", :dependent => :delete
  add_foreign_key "conversations", "users", :name => "conversations_user1_id_fk", :column => "user1_id", :dependent => :delete
  add_foreign_key "conversations", "users", :name => "conversations_user2_id_fk", :column => "user2_id", :dependent => :delete

  add_foreign_key "exercises", "exercise_types", :name => "exercises_exercise_type_id_fk", :dependent => :delete
  add_foreign_key "exercises", "trainings", :name => "exercises_training_id_fk", :dependent => :delete

  add_foreign_key "i18n_strings", "i18n_keys", :name => "i18n_strings_i18n_key_id_fk", :dependent => :delete

  add_foreign_key "measurement_comments", "series_executions", :name => "measurement_comments_series_executions_id_fk", :column => "series_executions_id", :dependent => :delete

  add_foreign_key "measurements", "trainings", :name => "measurements_training_id_fk", :dependent => :delete
  add_foreign_key "measurements", "users", :name => "measurements_user_id_fk", :dependent => :delete

  add_foreign_key "series", "exercises", :name => "series_exercise_id_fk", :dependent => :delete

  add_foreign_key "series_events", "measurements", :name => "series_events_measurement_id_fk", :dependent => :delete

  add_foreign_key "series_executions", "exercises", :name => "series_executions_exercise_id_fk", :dependent => :delete
  add_foreign_key "series_executions", "measurements", :name => "series_executions_measurement_id_fk", :dependent => :delete

  add_foreign_key "trainings", "users", :name => "trainings_trainee_user_id_fk", :column => "trainee_user_id", :dependent => :delete

  add_foreign_key "users", "users", :name => "users_trainer_id_fk", :column => "trainer_id", :dependent => :delete

end
