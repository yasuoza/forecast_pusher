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

ActiveRecord::Schema.define(:version => 6) do

  create_table "points", :force => true do |t|
    t.integer  "area_id"
    t.string   "area_name"
    t.integer  "pref_id"
    t.string   "pref_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "points", ["pref_id", "area_id"], :name => "index_points_on_pref_id_and_area_id"
  add_index "points", ["pref_id"], :name => "index_points_on_pref_id"

  create_table "users", :force => true do |t|
    t.string   "screen_name"
    t.integer  "pref_id"
    t.string   "area_id"
    t.string   "access_token"
    t.string   "access_token_secret"
    t.string   "name"
    t.integer  "next_info"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "update_error_count",  :default => 0,     :null => false
    t.boolean  "next_only",           :default => false
  end

  add_index "users", ["screen_name"], :name => "index_users_on_screen_name"

end
