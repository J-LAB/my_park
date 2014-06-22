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

ActiveRecord::Schema.define(version: 20140622031609) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "districts", force: true do |t|
    t.spatial  "boundary",   limit: {:srid=>4326, :type=>"geometry", :geographic=>true}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "park_areas", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "zipcode"
    t.decimal  "acres"
    t.spatial  "boundary",   limit: {:srid=>4326, :type=>"geometry", :geographic=>true}
    t.integer  "park_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "park_entrances", force: true do |t|
    t.string   "access_type"
    t.string   "address"
    t.boolean  "primary"
    t.string   "features"
    t.spatial  "coordinates", limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.integer  "park_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parks", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "zipcode"
    t.decimal  "acres"
    t.spatial  "boundary",    limit: {:srid=>4326, :type=>"geometry", :geographic=>true}
    t.integer  "district_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pins", force: true do |t|
    t.spatial  "coordinates", limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.string   "position"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: true do |t|
    t.spatial  "coordinates",     limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.string   "comments"
    t.integer  "uploader_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
  end

  create_table "trails", force: true do |t|
    t.string   "name"
    t.string   "trail_type"
    t.string   "material"
    t.integer  "width"
    t.decimal  "length"
    t.spatial  "geospatial_data", limit: {:srid=>4326, :type=>"geometry", :geographic=>true}
    t.integer  "park_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "limits"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "username"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
