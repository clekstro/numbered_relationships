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

ActiveRecord::Schema.define(:version => 20120904075907) do

  create_table "jesters", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "jesters_kingly_courts", :force => true do |t|
    t.integer "kingly_court_id"
    t.integer "jester_id"
  end

  create_table "jokes", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "punch_line"
    t.boolean  "funny"
    t.integer  "jester_id"
  end

  create_table "kingly_courts", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
  end

  create_table "kingly_courts_performances", :force => true do |t|
    t.integer "kingly_court_id"
    t.integer "performance_id"
  end

  create_table "laughs", :force => true do |t|
    t.integer  "volume"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "joke_id"
  end

  create_table "performances", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "repertoire_id"
  end

  create_table "repertoires", :force => true do |t|
    t.integer  "jester_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
