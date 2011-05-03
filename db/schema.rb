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

ActiveRecord::Schema.define(:version => 20110503202716) do

  create_table "artefacts", :force => true do |t|
    t.string   "artefactid"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.boolean  "visible",            :default => true
  end

  add_index "artefacts", ["user_id"], :name => "index_artefacts_on_user_id"

  create_table "comments", :force => true do |t|
    t.string   "content"
    t.integer  "artefact_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["artefact_id"], :name => "index_comments_on_artefact_id"

  create_table "loans", :force => true do |t|
    t.integer  "user_id"
    t.integer  "artefact_id"
    t.date     "loan_start"
    t.date     "loan_end"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "loans", ["artefact_id"], :name => "index_loans_on_loaned_id"
  add_index "loans", ["user_id"], :name => "index_loans_on_loaner_id"

  create_table "users", :force => true do |t|
    t.string   "userid"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.boolean  "administrator",      :default => false
    t.string   "address"
    t.string   "city"
    t.string   "postcode"
    t.string   "country"
    t.string   "mobile"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.float    "long"
    t.float    "lat"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
