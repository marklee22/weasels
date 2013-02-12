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

ActiveRecord::Schema.define(:version => 20130212185508) do

  create_table "nfl_teams", :force => true do |t|
    t.string   "location"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "abbr"
  end

  add_index "nfl_teams", ["location"], :name => "index_nfl_teams_on_location"
  add_index "nfl_teams", ["name"], :name => "index_nfl_teams_on_name"

  create_table "picks", :force => true do |t|
    t.integer  "user_id"
    t.integer  "pick_team_id"
    t.integer  "spread_id"
    t.integer  "wildcard"
    t.boolean  "bye"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "picks", ["spread_id"], :name => "index_picks_on_spread_id"
  add_index "picks", ["user_id"], :name => "index_picks_on_user_id"

  create_table "spreads", :force => true do |t|
    t.integer  "year"
    t.integer  "week"
    t.integer  "favored_team_id"
    t.integer  "under_team_id"
    t.decimal  "spread"
    t.boolean  "favored_won"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.boolean  "is_favored_home_team"
    t.integer  "favored_team_score"
    t.integer  "under_team_score"
  end

  add_index "spreads", ["week"], :name => "index_spreads_on_week"
  add_index "spreads", ["year"], :name => "index_spreads_on_year"

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin"
    t.string   "team_name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_me"

end
