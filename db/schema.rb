# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_04_14_184535) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "ahoy_events", force: :cascade do |t|
    t.bigint "visit_id"
    t.bigint "user_id"
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "app_version"
    t.string "os_version"
    t.string "platform"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
  end

  create_table "annotation_relations", force: :cascade do |t|
    t.float "score"
    t.string "kind"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "annotation_id"
    t.integer "related_annotation_id"
    t.index ["annotation_id"], name: "index_annotation_relations_on_annotation_id"
  end

  create_table "annotation_traits", force: :cascade do |t|
    t.string "name"
    t.float "score"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "annotation_id", null: false
    t.index ["annotation_id"], name: "index_annotation_traits_on_annotation_id"
  end

  create_table "annotations", force: :cascade do |t|
    t.bigint "transcript_segment_id"
    t.integer "begin_offset"
    t.integer "end_offset"
    t.float "score"
    t.string "text"
    t.string "category"
    t.string "kind"
    t.json "traits"
    t.json "sub_annotations"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "start_time"
    t.float "end_time"
    t.integer "aws_id"
    t.boolean "top"
    t.string "medline_summary"
    t.string "medline_url"
    t.index ["transcript_segment_id"], name: "index_annotations_on_transcript_segment_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "links", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "label"
    t.string "url"
    t.integer "utterance_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "recording_id"
    t.bigint "message_template_id"
    t.datetime "deliver_at"
    t.boolean "deliver"
    t.datetime "delivered_at"
    t.boolean "to_email"
    t.boolean "to_sms"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "mailer_method"
    t.string "sms_text_function"
    t.index ["message_template_id"], name: "index_messages_on_message_template_id"
    t.index ["recording_id"], name: "index_messages_on_recording_id"
  end

  create_table "orgs", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "contact_email_address"
  end

  create_table "recording_notes", force: :cascade do |t|
    t.bigint "recording_id"
    t.string "text"
    t.float "at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["recording_id"], name: "index_recording_notes_on_recording_id"
  end

  create_table "recordings", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "duration"
    t.boolean "is_video"
    t.string "aws_bucket_name"
    t.string "aws_public_url"
    t.string "aws_media_key"
    t.string "aws_transcription_uri"
    t.string "media_format"
    t.string "sha1"
    t.boolean "is_processed", default: false
    t.bigint "ahoy_visit_id"
    t.datetime "next_appt_at"
    t.string "title"
    t.string "provider"
    t.json "transcript_json"
    t.json "annotation_json"
    t.integer "speakers"
    t.boolean "user_can_access"
  end

  create_table "shares", force: :cascade do |t|
    t.bigint "user_id"
    t.string "shared_with_user_id"
    t.datetime "revoked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_shares_on_user_id"
  end

  create_table "tag_types", id: :serial, force: :cascade do |t|
    t.text "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.integer "utterance_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tag_type_id"
    t.index ["tag_type_id"], name: "index_tags_on_tag_type_id"
    t.index ["utterance_id"], name: "index_tags_on_utterance_id"
  end

  create_table "transcript_items", force: :cascade do |t|
    t.bigint "recording_id"
    t.float "start_time"
    t.float "end_time"
    t.string "kind"
    t.string "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "begin_offset"
    t.integer "end_offset"
    t.index ["recording_id"], name: "index_transcript_items_on_recording_id"
  end

  create_table "transcript_segments", force: :cascade do |t|
    t.bigint "recording_id"
    t.float "start_time"
    t.float "end_time"
    t.string "speaker_label"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["recording_id"], name: "index_transcript_segments_on_recording_id"
  end

  create_table "user_fields", force: :cascade do |t|
    t.string "text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "type"
    t.integer "recording_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
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
    t.boolean "active", default: true, null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.datetime "phone_confirmed_at"
    t.string "phone_token"
    t.boolean "requires_phone_confirmation"
    t.boolean "onboarded", default: false
    t.string "locale"
    t.boolean "email_notifications"
    t.boolean "sms_notifications"
    t.integer "org_id"
    t.string "timezone"
    t.boolean "can_record"
    t.boolean "created_as_caregiver"
    t.boolean "anc_view_tags"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "utterances", id: :serial, force: :cascade do |t|
    t.integer "index"
    t.float "begins_at"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "ends_at"
    t.integer "recording_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "annotation_traits", "annotations"
  add_foreign_key "tags", "tag_types"
end
