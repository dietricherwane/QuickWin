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

<<<<<<< HEAD
ActiveRecord::Schema.define(version: 20150330080312) do
=======
ActiveRecord::Schema.define(version: 20150429054417) do
>>>>>>> c4f7baa413cff998de2cab4a4c64070039e4a20f

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "message_logs", force: true do |t|
    t.integer  "subscriber_id"
<<<<<<< HEAD
    t.string   "msisdn",             limit: 8
=======
>>>>>>> c4f7baa413cff998de2cab4a4c64070039e4a20f
    t.integer  "profile_id"
    t.integer  "period_id"
    t.integer  "sms_transaction_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",             limit: 200
    t.string   "message_id",         limit: 200
<<<<<<< HEAD
=======
    t.string   "msisdn"
>>>>>>> c4f7baa413cff998de2cab4a4c64070039e4a20f
  end

  add_index "message_logs", ["period_id"], name: "index_message_logs_on_period_id", using: :btree
  add_index "message_logs", ["profile_id"], name: "index_message_logs_on_profile_id", using: :btree
  add_index "message_logs", ["sms_transaction_id"], name: "index_message_logs_on_sms_transaction_id", using: :btree
  add_index "message_logs", ["subscriber_id"], name: "index_message_logs_on_subscriber_id", using: :btree

  create_table "periods", force: true do |t|
    t.string   "name",           limit: 100
    t.integer  "number_of_days"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", force: true do |t|
    t.string   "name",       limit: 100
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "registration_logs", force: true do |t|
    t.integer  "subscriber_id"
    t.integer  "profile_id"
    t.integer  "period_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "registration_logs", ["period_id"], name: "index_registration_logs_on_period_id", using: :btree
  add_index "registration_logs", ["profile_id"], name: "index_registration_logs_on_profile_id", using: :btree
  add_index "registration_logs", ["subscriber_id"], name: "index_registration_logs_on_subscriber_id", using: :btree

  create_table "sms_providers", force: true do |t|
    t.string   "name",       limit: 100
    t.string   "url",        limit: 200
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sms_transactions", force: true do |t|
    t.datetime "started_at"
    t.datetime "ended_at"
    t.integer  "profile_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "send_messages",      limit: 8
    t.integer  "failed_messages",    limit: 8
    t.integer  "number_of_messages", limit: 8
  end

  add_index "sms_transactions", ["profile_id"], name: "index_sms_transactions_on_profile_id", using: :btree

  create_table "subscribers", force: true do |t|
    t.string   "name",                     limit: 100
<<<<<<< HEAD
    t.string   "msisdn",                   limit: 8
=======
>>>>>>> c4f7baa413cff998de2cab4a4c64070039e4a20f
    t.integer  "profile_id"
    t.integer  "period_id"
    t.datetime "last_registration_date"
    t.integer  "last_registration_period"
    t.integer  "registrations_times"
    t.integer  "received_messages"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
<<<<<<< HEAD
  end

  add_index "subscribers", ["msisdn"], name: "index_subscribers_on_msisdn", using: :btree
=======
    t.string   "msisdn"
  end

>>>>>>> c4f7baa413cff998de2cab4a4c64070039e4a20f
  add_index "subscribers", ["period_id"], name: "index_subscribers_on_period_id", using: :btree
  add_index "subscribers", ["profile_id"], name: "index_subscribers_on_profile_id", using: :btree

end
