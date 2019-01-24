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

ActiveRecord::Schema.define(version: 2019_01_24_222631) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "recordings", force: :cascade do |t|
    t.integer "user_id"
    t.string "filetype"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.integer "duration"
    t.string "patient_identifier"
    t.string "file_name"
    t.string "file_hash"
    t.string "uri"
  end

  create_table "shares", force: :cascade do |t|
    t.bigint "user_id"
    t.string "shared_with_user_id"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_shares_on_user_id"
  end

  create_table "tag_types", force: :cascade do |t|
    t.text "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.integer "utterance_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tag_type_id"
    t.index ["tag_type_id"], name: "index_tags_on_tag_type_id"
    t.index ["utterance_id"], name: "index_tags_on_utterance_id"
  end

  create_table "transcripts", force: :cascade do |t|
    t.integer "recording_id"
    t.integer "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "json"
  end

  create_table "user_notes", force: :cascade do |t|
    t.string "text"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "recording_id"
    t.index ["recording_id"], name: "index_user_notes_on_recording_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.integer "invited_by_id"
    t.integer "invitations_count", default: 0
    t.string "role"
    t.string "otp_auth_secret"
    t.string "otp_recovery_secret"
    t.boolean "otp_enabled", default: false, null: false
    t.boolean "otp_mandatory", default: false, null: false
    t.datetime "otp_enabled_on"
    t.integer "otp_failed_attempts", default: 0, null: false
    t.integer "otp_recovery_counter", default: 0, null: false
    t.string "otp_persistence_seed"
    t.string "otp_session_challenge"
    t.datetime "otp_challenge_expires"
    t.boolean "active", default: true, null: false
    t.string "first_name"
    t.string "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["otp_challenge_expires"], name: "index_users_on_otp_challenge_expires"
    t.index ["otp_session_challenge"], name: "index_users_on_otp_session_challenge", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "utterances", force: :cascade do |t|
    t.integer "transcript_id"
    t.integer "index"
    t.float "begins_at"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "ends_at"
  end

  add_foreign_key "tags", "tag_types"
end
