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

ActiveRecord::Schema.define(:version => 20170115102017) do

  create_table "appearances", :force => true do |t|
    t.integer  "performance_id"
    t.integer  "participant_id"
    t.integer  "instrument_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "points"
    t.string   "participant_role"
  end

  add_index "appearances", ["participant_id"], :name => "index_appearances_on_participant_id"
  add_index "appearances", ["performance_id", "participant_id"], :name => "index_appearances_on_entry_id_and_participant_id", :unique => true
  add_index "appearances", ["performance_id"], :name => "index_appearances_on_entry_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.boolean  "solo"
    t.boolean  "ensemble"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "slug"
    t.string   "official_min_age_group", :default => "Ia"
    t.string   "official_max_age_group", :default => "VII"
    t.integer  "max_round"
    t.string   "genre"
  end

  add_index "categories", ["max_round"], :name => "index_categories_on_max_round"

  create_table "contest_categories", :force => true do |t|
    t.integer  "contest_id",  :null => false
    t.integer  "category_id", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "contests", :force => true do |t|
    t.integer  "host_id"
    t.date     "begins"
    t.date     "ends"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.date     "certificate_date"
    t.integer  "season"
    t.date     "signup_deadline"
    t.boolean  "timetables_public", :default => false
    t.integer  "round"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "hosts", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "city"
    t.string   "time_zone",    :default => "Europe/Berlin"
    t.string   "country_code"
  end

  create_table "hosts_users", :id => false, :force => true do |t|
    t.integer "host_id"
    t.integer "user_id"
  end

  create_table "instruments", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "participants", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.date     "birthdate"
    t.string   "phone"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "performances", :force => true do |t|
    t.datetime "stage_time"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "tracing_code"
    t.string   "age_group"
    t.integer  "predecessor_id"
    t.integer  "stage_venue_id"
    t.integer  "contest_category_id"
    t.boolean  "results_public",      :default => false, :null => false
  end

  add_index "performances", ["stage_venue_id"], :name => "index_performances_on_stage_venue_id"
  add_index "performances", ["tracing_code"], :name => "index_performances_on_tracing_code", :unique => true

  create_table "pieces", :force => true do |t|
    t.string   "title"
    t.integer  "performance_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "minutes"
    t.integer  "seconds"
    t.string   "composer_name"
    t.string   "composer_born"
    t.string   "composer_died"
    t.string   "epoch"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.boolean  "admin"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "venues", :force => true do |t|
    t.string   "name"
    t.integer  "host_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
