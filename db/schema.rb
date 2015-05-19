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

ActiveRecord::Schema.define(version: 20150512200850) do

  create_table "blacklight_folders_folder_items", force: true do |t|
    t.integer  "folder_id",   null: false
    t.integer  "bookmark_id", null: false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  add_index "blacklight_folders_folder_items", ["bookmark_id"], name: "index_blacklight_folders_folder_items_on_bookmark_id", using: :btree
  add_index "blacklight_folders_folder_items", ["folder_id"], name: "index_blacklight_folders_folder_items_on_folder_id", using: :btree

  create_table "blacklight_folders_folders", force: true do |t|
    t.string   "name"
    t.integer  "user_id",                       null: false
    t.string   "user_type",                     null: false
    t.string   "visibility"
    t.integer  "number_of_members", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  add_index "blacklight_folders_folders", ["user_id", "user_type"], name: "index_blacklight_folders_folders_on_user_id_and_user_type", using: :btree

  create_table "bookmarks", force: true do |t|
    t.integer  "user_id",       null: false
    t.string   "user_type"
    t.string   "document_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "document_type"
  end

  add_index "bookmarks", ["user_id"], name: "index_bookmarks_on_user_id", using: :btree

  create_table "featured_boards", force: true do |t|
    t.string   "title"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published"
  end

  create_table "featured_images", force: true do |t|
    t.string   "title"
    t.string   "record_id"
    t.string   "uploaded_image"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "file_caches", force: true do |t|
    t.string   "record_id"
    t.string   "url"
    t.boolean  "valid_content"
    t.string   "content_type"
    t.string   "filepath"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flag_votes", force: true do |t|
    t.integer  "user_id"
    t.integer  "flag_id"
    t.integer  "weight"
    t.string   "record_id",  limit: 40
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "flag_votes", ["user_id", "flag_id", "record_id"], name: "index_flag_votes_on_user_id_and_flag_id_and_record_id", unique: true, using: :btree

  create_table "flags", force: true do |t|
    t.string   "on_text"
    t.string   "off_text"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "on_text_display"
    t.string   "off_text_display"
    t.string   "css"
    t.integer  "search_filter_threshold"
  end

  create_table "searches", force: true do |t|
    t.text     "query_params", limit: 16777215
    t.integer  "user_id"
    t.string   "user_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "searches", ["user_id"], name: "index_searches_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "guest",                  default: false
    t.string   "avatar"
    t.string   "name"
    t.string   "twitter_handle"
    t.text     "biography"
    t.integer  "roles_mask"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
