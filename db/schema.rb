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

ActiveRecord::Schema.define(version: 20140621163600) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "districts", force: true do |t|
    t.spatial  "boundary",   limit: {:srid=>4326, :type=>"geometry", :geographic=>true}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "park_entrances", force: true do |t|
    t.string   "type"
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

  create_table "trails", force: true do |t|
    t.string   "name"
    t.string   "type"
    t.string   "material"
    t.integer  "width"
    t.decimal  "length"
    t.spatial  "geospatial_data", limit: {:srid=>4326, :type=>"geometry", :geographic=>true}
    t.integer  "park_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "limits"
  end

end
