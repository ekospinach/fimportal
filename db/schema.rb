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

ActiveRecord::Schema.define(:version => 20130414155210) do

  create_table "profile_candidates", :force => true do |t|
    t.string   "fullname"
    t.date     "dob"
    t.string   "place_of_birth"
    t.text     "location"
    t.binary   "gender"
    t.string   "religion"
    t.string   "phone"
    t.text     "hobby"
    t.string   "blood_type"
    t.string   "school"
    t.integer  "batch"
    t.text     "non_formal_education"
    t.text     "organization"
    t.text     "committee"
    t.text     "workshop"
    t.text     "motivation"
    t.string   "information_from"
    t.integer  "application_count"
    t.text     "performance_type"
    t.text     "referal"
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "user_id"
    t.text     "agreement"
    t.text     "biodata"
    t.string   "photo"
    t.string   "recommendation_letter"
    t.string   "status",                      :default => "NOT SUBMITTED"
    t.text     "inspiring_story"
    t.text     "collaboration"
    t.string   "province"
    t.boolean  "is_photo_visible_to_public",  :default => false
    t.boolean  "is_visible_to_public",        :default => true
    t.string   "facebook"
    t.string   "twitter"
    t.boolean  "is_email_displayed",          :default => false
    t.integer  "marked_by_id"
    t.datetime "submitted_at"
    t.integer  "organization_point",          :default => 0
    t.integer  "committee_point",             :default => 0
    t.integer  "personal_knowledge_point",    :default => 0
    t.integer  "document_completeness_point", :default => 0
    t.integer  "reliability_point",           :default => 0
    t.integer  "willingness_point",           :default => 0
    t.text     "special_location_comment"
    t.text     "special_character_comment"
    t.boolean  "is_announcement_displayed",   :default => false
    t.boolean  "is_update_allowed",           :default => false
    t.boolean  "is_accepted",                 :default => false
    t.string   "accepted_location"
    t.integer  "accepted_location_choices",   :default => 0
  end

  add_index "profile_candidates", ["user_id"], :name => "index_profile_candidates_on_user_id", :unique => true

  create_table "profiles", :force => true do |t|
    t.string   "fullname"
    t.date     "dob"
    t.string   "place_of_birth"
    t.string   "location"
    t.text     "motto"
    t.text     "interest"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.integer  "user_id"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "batch"
    t.text     "program"
    t.string   "facebook"
    t.string   "twitter"
    t.boolean  "is_email_displayed", :default => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
