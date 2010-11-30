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

ActiveRecord::Schema.define(:version => 20101121203950) do

  create_table "accounts", :force => true do |t|
    t.boolean  "customer_location_access"
    t.boolean  "user_location_access"
    t.string   "time_zone"
    t.integer  "account_number"
    t.string   "name"
    t.string   "sub_domain"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "beds", :force => true do |t|
    t.integer  "salon_id"
    t.integer  "bed_number"
    t.integer  "level"
    t.string   "name"
    t.integer  "max_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", :force => true do |t|
    t.string   "last_name"
    t.string   "first_name"
    t.integer  "customer_number"
    t.integer  "level"
    t.string   "email"
    t.string   "phone_number"
    t.string   "address"
    t.string   "address_2"
    t.date     "birth_date"
    t.string   "city"
    t.string   "zip_code"
    t.string   "state"
    t.integer  "account_id"
    t.integer  "salon_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "salons", :force => true do |t|
    t.integer  "account_id"
    t.string   "name"
    t.string   "zip_code"
    t.boolean  "rfid_login"
    t.string   "permalink"
    t.string   "time_zone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tan_sessions", :force => true do |t|
    t.integer  "bed_id"
    t.integer  "customer_id"
    t.integer  "salon_id"
    t.integer  "minutes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "last_name"
    t.string   "first_name"
    t.integer  "security_level"
    t.integer  "account_id"
    t.integer  "salon_id"
    t.string   "login"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
