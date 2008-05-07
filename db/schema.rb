# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 2) do

  create_table "feeds", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "link_regexp"
    t.string   "title_regexp"
    t.string   "content_regexp"
    t.string   "more_regexp"
    t.text     "link"
    t.integer  "more"
    t.datetime "last_published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.string   "title"
    t.text     "link"
    t.binary   "content"
    t.integer  "feed_id"
    t.integer  "guid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
