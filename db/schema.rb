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
    t.string   "account_number"
    t.string   "name"
    t.string   "sub_domain"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts", ["sub_domain"], :name => "index_accounts_on_sub_domain", :unique => true

  create_table "beds", :force => true do |t|
    t.integer  "salon_id"
    t.integer  "bed_number"
    t.integer  "level"
    t.string   "name"
    t.integer  "max_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "beds", ["salon_id"], :name => "index_beds_on_salon_id"

  create_table "customers", :force => true do |t|
    t.string   "last_name"
    t.string   "first_name"
    t.string   "customer_number"
    t.integer  "level",           :default => 0
    t.string   "email"
    t.string   "phone_number"
    t.string   "address"
    t.string   "address_2"
    t.string   "city"
    t.string   "zip_code"
    t.string   "state"
    t.integer  "account_id"
    t.integer  "salon_id"
    t.boolean  "under_18",        :default => false
    t.integer  "customer_type",   :default => 0
    t.date     "paid_through"
    t.integer  "sessions_left"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "customers", ["account_id"], :name => "index_customers_on_account_id"
  add_index "customers", ["salon_id"], :name => "index_customers_on_salon_id"

  create_table "salons", :force => true do |t|
    t.integer  "account_id"
    t.string   "zip_code"
    t.string   "identifier"
    t.string   "time_zone"
    t.string   "address"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "staffed_hours"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "salons", ["account_id", "identifier"], :name => "index_salons_on_account_id_and_identifier", :unique => true

  create_table "tan_sessions", :force => true do |t|
    t.integer  "bed_id"
    t.integer  "customer_id"
    t.integer  "salon_id"
    t.integer  "minutes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tan_sessions", ["customer_id"], :name => "index_tan_sessions_on_customer_id"
  add_index "tan_sessions", ["salon_id"], :name => "index_tan_sessions_on_salon_id"

  create_table "users", :force => true do |t|
    t.string   "last_name"
    t.string   "first_name"
    t.integer  "security_level",       :default => 0
    t.integer  "account_id"
    t.integer  "salon_id"
    t.string   "login"
    t.boolean  "access_all_locations", :default => false
    t.string   "encrypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["account_id"], :name => "index_users_on_account_id"
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["salon_id"], :name => "index_users_on_salon_id"

end
