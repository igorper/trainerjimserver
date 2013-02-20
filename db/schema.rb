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

ActiveRecord::Schema.define(:version => 20130217115141) do

  create_table "exercises", :force => true do |t|
    t.integer  "training_id", :null => false
    t.string   "name"
    t.integer  "order"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
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

  create_table "measurements", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.binary   "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "measurements", ["user_id"], :name => "index_measurements_on_user_id"

  create_table "series", :force => true do |t|
    t.integer  "exercise_id",  :null => false
    t.integer  "order"
    t.integer  "repeat_count"
    t.integer  "weight"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "series", ["exercise_id"], :name => "index_series_on_exercise_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "trainings", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "trainer_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "trainings", ["trainer_id"], :name => "index_trainings_on_trainer_id"
  add_index "trainings", ["user_id"], :name => "index_trainings_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.integer  "role"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "first_name"
    t.string   "last_names"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

  add_foreign_key "exercises", "trainings", :name => "exercises_training_id_fk", :dependent => :delete

  add_foreign_key "i18n_strings", "i18n_keys", :name => "i18n_strings_i18n_key_id_fk", :dependent => :delete

  add_foreign_key "measurements", "users", :name => "measurements_user_id_fk", :dependent => :delete

  add_foreign_key "series", "exercises", :name => "series_exercise_id_fk", :dependent => :delete

  add_foreign_key "trainings", "users", :name => "trainings_trainer_id_fk", :column => "trainer_id", :dependent => :nullify
  add_foreign_key "trainings", "users", :name => "trainings_user_id_fk", :dependent => :delete

end
