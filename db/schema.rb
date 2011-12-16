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

ActiveRecord::Schema.define(:version => 20111216025752) do

  create_table "authorizations", :force => true do |t|
    t.string   "provider",   :null => false
    t.string   "uid",        :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authorizations", ["provider", "uid"], :name => "index_authorizations_on_provider_and_uid"
  add_index "authorizations", ["user_id"], :name => "index_authorizations_on_user_id"

  create_table "feeds", :force => true do |t|
    t.string   "title"
    t.string   "url",         :null => false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feeds", ["url"], :name => "index_feeds_on_url"

  create_table "items", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "guid"
    t.integer  "feed_id"
    t.string   "enclosure_url"
    t.string   "enclosure_length"
    t.string   "enclosure_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "items", ["feed_id"], :name => "index_items_on_feed_id"

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "feed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscriptions", ["feed_id"], :name => "index_subscriptions_on_feed_id"
  add_index "subscriptions", ["user_id"], :name => "index_subscriptions_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "nickname",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
