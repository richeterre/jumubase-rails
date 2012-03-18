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

ActiveRecord::Schema.define(:version => 20120318022257) do

  create_table "appearances", :force => true do |t|
    t.integer  "entry_id"
    t.integer  "participant_id"
    t.integer  "instrument_id"
    t.integer  "role_id"
    t.integer  "points"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "appearances", ["entry_id", "participant_id"], :name => "index_appearances_on_entry_id_and_participant_id", :unique => true
  add_index "appearances", ["entry_id"], :name => "index_appearances_on_entry_id"
  add_index "appearances", ["participant_id"], :name => "index_appearances_on_participant_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.boolean  "solo"
    t.boolean  "ensemble"
    t.boolean  "pop"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories_competitions", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "competition_id"
  end

  create_table "competitions", :force => true do |t|
    t.integer  "round_id"
    t.integer  "host_id"
    t.date     "begins"
    t.date     "ends"
    t.date     "certificate_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "composers", :force => true do |t|
    t.string   "name"
    t.string   "born"
    t.string   "died"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entries", :force => true do |t|
    t.string   "edit_code"
    t.integer  "category_id"
    t.integer  "competition_id"
    t.integer  "first_competition_id"
    t.integer  "warmup_venue_id"
    t.integer  "stage_venue_id"
    t.datetime "warmup_time"
    t.datetime "stage_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "entries", ["edit_code"], :name => "index_entries_on_edit_code", :unique => true

  create_table "epoches", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hosts", :force => true do |t|
    t.string   "name"
    t.string   "city"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hosts_users", :id => false, :force => true do |t|
    t.integer "host_id"
    t.integer "user_id"
  end

  create_table "instruments", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "participants", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.date     "birthdate"
    t.string   "street"
    t.string   "postal_code"
    t.string   "city"
    t.integer  "country_id"
    t.string   "phone"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pieces", :force => true do |t|
    t.string   "title"
    t.integer  "composer_id"
    t.integer  "entry_id"
    t.integer  "epoch_id"
    t.string   "duration"
    t.integer  "minutes"
    t.integer  "seconds"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rounds", :force => true do |t|
    t.integer  "level"
    t.string   "name"
    t.string   "slug"
    t.string   "board_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "password_digest"
    t.string   "encrypted_password"
    t.boolean  "admin"
    t.string   "salt"
    t.datetime "last_login"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  create_table "venues", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.integer  "host_id"
    t.string   "address"
    t.string   "usage"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
