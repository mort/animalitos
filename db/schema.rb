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

ActiveRecord::Schema.define(:version => 20130329224811) do

  create_table "animalitos", :force => true do |t|
    t.string   "name"
    t.string   "uuid"
    t.boolean  "leashed"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "bonds", :force => true do |t|
    t.integer  "player_id"
    t.integer  "animalito_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "feedings", :force => true do |t|
    t.integer  "animalito_id"
    t.string   "img_url"
    t.integer  "luma_value"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "journeys", :force => true do |t|
    t.integer  "animalito_id"
    t.boolean  "open"
    t.datetime "created_at"
    t.datetime "finished_at"
  end

  create_table "journeys_locations", :force => true do |t|
    t.integer  "journey_id"
    t.integer  "location_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "likings", :force => true do |t|
    t.integer  "animalito_id"
    t.string   "uri"
    t.string   "liking_type"
    t.string   "sign"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "locations", :force => true do |t|
    t.string   "geohash"
    t.string   "csquare"
    t.float    "lat"
    t.float    "lon"
    t.float    "true_lat"
    t.float    "true_lon"
    t.integer  "altitude"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "players", :force => true do |t|
    t.string   "name"
    t.string   "uuid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "positions", :force => true do |t|
    t.integer  "location_id"
    t.integer  "actor_id"
    t.string   "actor_type"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "score_values", :force => true do |t|
    t.integer  "score_id"
    t.integer  "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "scores", :force => true do |t|
    t.integer  "animalito_id"
    t.string   "name"
    t.integer  "max_value"
    t.integer  "min_value"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "scuffles", :force => true do |t|
    t.integer  "a1_id"
    t.integer  "a2_id"
    t.boolean  "over"
    t.boolean  "tie"
    t.integer  "winner_id"
    t.integer  "loser_id"
    t.integer  "location_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
