Rails.application.routes.draw do

  # TODO Clean this file up. Make it resourceful.

  devise_for :users, controllers: {invitations: 'invitations'} 
  devise_scope :user do
    get 'test_invitation', to: 'invitations#test_invitation'
    post 'post_test_invitation', to: 'invitations#post_test_invitation'
  end

  root 'home#index'

  resources :recordings
  resources :tags
  resources :links
  resources :utterances
  resources :clicks, only: [:create]

  get 'toggle_locale',                 to: 'home#toggle_locale',                 as: 'toggle_locale'
  post 'set_locale_cookie',            to: 'application#set_locale_cookie',      as: 'set_locale_cookie'

  post 'destroy_tags/:id',             to: 'tags#destroy_for_utterance',         as: 'destroy_tags'
  post 'destroy_links/:id',            to: 'links#destroy_for_utterance',        as: 'destroy_links'

  # Admin
  get 'admin',                         to: 'admin#index'
  get 'manage_recordings',             to: 'admin#manage_recordings',            as: 'manage_recordings'
  get 'tag_recording/:id',             to: 'admin#tag_recording',                as: 'tag_recording'
  get 'users',                         to: 'admin#users'
  get 'toggle_active/:id',             to: 'admin#toggle_active',                as: 'toggle_active'
  get 'toggle_can_record/:id',         to: 'admin#toggle_can_record',            as: 'toggle_can_record'
  get 'toggle_otp/:id',                to: 'admin#toggle_otp',                   as: 'toggle_otp'
  get 'new_registration',              to: 'admin#new_registration'
  post 'set_password',                 to: 'admin#set_password'
  post 'create_registration',          to: 'admin#create_registration'
  post 'create_registration2',          to: 'admin#create_registration2'
  get 'switch_user_select',            to: 'admin#switch_user_select'
  post 'switch_to_user',               to: 'admin#switch_to_user'
  get 'new_caregiver',                 to: 'admin#new_caregiver'
  post 'create_caregiver',             to: 'admin#create_caregiver'
  get 'new_org',                       to: 'admin#new_org',                      as: 'new_org'
  post 'create_org',                   to: 'admin#create_org',                   as: 'create_org'
  post 'update_contact_email_address', to: 'admin#update_contact_email_address', as: 'update_contact_email_address'
  post 'update_redcap_id',             to: 'admin#update_redcap_id',             as: 'update_redcap_id'
  post 'update_phone_number',          to: 'admin#update_phone_number',          as: 'update_phone_number'
  post 'update_followup_message',      to: 'admin#update_followup_message',      as: 'update_followup_message'

  # Reports (Admin)
  get 'dashboard',                     to: 'reports#dashboard',                  as: 'dashboard'

  # Recording
  get 'record',                        to: 'record#new'
  get 'file_upload',                   to: 'record#file_upload',                 as: 'file_upload'
  post 'upload',                       to: 'record#upload',                      as: 'upload'
  post 'upload_file',                  to: 'record#upload_file',                 as: 'upload_file'
  get 'recording_saved',               to: 'record#saved'
  get 'upload_transcript',             to: 'record#upload_transcript',           as: 'upload_transcript'
  post 'create_utterances',            to: 'record#create_utterances',           as: 'create_utterances'

  # Recordings
  get 'get_metadata/:id',              to: 'recordings#get_metadata',            as: 'get_metadata'
  post 'update_metadata',              to: 'recordings#update_metadata',         as: 'update_metadata'
  get 'get_notes/:id',                 to: 'recordings#get_notes',               as: 'get_notes'
  post 'upsert_note',                  to: 'recordings#upsert_note',             as: 'upsert_note'
  post 'delete_note',                  to: 'recordings#delete_note',             as: 'delete_note'

  # Playback
  get 'play(/:id)',                    to: 'play#index',                         as: 'play'

  # Sharing
  resources :shares, controller: :share
  get 'no_shares',                     to: 'share#no_shares',                    as: 'no_shares'
  get 'twilio/sms',                    to: 'twilio#sms'

  # Help
  get 'help',                          to: 'help#index',                         as: 'help'
  get 'intro_video',                   to: 'help#intro_video',                   as: 'intro_video'
  get 'dont_onboard',                  to: 'help#dont_onboard',                  as: 'dont_onboard'
  get 'set_onboarded',                 to: 'help#set_onboarded',                 as: 'set_onboarded'
  get 'play/view_transcript/:id',      to: 'help#view_transcript',               as: 'view_transcript'

  # Analytics
  get 'analytics(/:id)',               to: 'analytics#index',                    as: 'analytics'

end
