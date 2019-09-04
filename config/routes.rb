Rails.application.routes.draw do

  # TODO Clean this file up. Make it resourceful.

  devise_for :users, controllers: {invitations: 'invitations'}

  root 'home#index'

  resources :recordings
  resources :tags
  resources :links
  resources :utterances

  post 'destroy_tags/:id',          to: 'tags#destroy_for_utterance',       as: 'destroy_tags'
  post 'destroy_links/:id',         to: 'links#destroy_for_utterance',      as: 'destroy_links'

  # Admin
  get 'admin',                       to: 'admin#index'
  get 'manage_recordings',           to: 'admin#manage_recordings',          as: 'manage_recordings'
  get 'tag_recording/:id',           to: 'admin#tag_recording',              as: 'tag_recording'
  get 'users',                       to: 'admin#users'
  get 'toggle_active/:id',           to: 'admin#toggle_active',              as: 'toggle_active'
  get 'toggle_otp/:id',              to: 'admin#toggle_otp',                 as: 'toggle_otp'
  get 'new_registration',            to: 'admin#new_registration'
  post 'set_password',               to: 'admin#set_password'
  post 'create_registration',        to: 'admin#create_registration'
  get 'switch_to_new_user',          to: 'admin#switch_to_new_user'

  # Recording
  get 'record',                      to: 'record#new' 
  get 'file_upload',                 to: 'record#file_upload',               as: 'file_upload'
  post 'upload',                     to: 'record#upload',                    as: 'upload'
  post 'upload_file',                to: 'record#upload_file',               as: 'upload_file'
  get 'recording_saved',             to: 'record#saved'
  get 'upload_transcript',           to: 'record#upload_transcript',         as: 'upload_transcript'
  post 'create_utterances',          to: 'record#create_utterances',         as: 'create_utterances'

  # Playback
  get 'my_recordings',               to: 'play#index',                       as: 'my_recordings'
  get 'play/:id',                    to: 'play#play',                        as: 'play'
  get 'play/rm_tmp_file/:id',        to: 'play#rm_tmp_file'

  # TODO One of these needs to go
  post 'play/user_field',            to: 'play#user_field'
  post 'user_field',                 to: 'play#user_field'

  get 'send_media/:id',              to: 'play#send_media',                  as: 'send_media'

  # Sharing
  resources :shares, controller: :share
  get 'no_shares',                   to: 'share#no_shares',                  as: 'no_shares'
  get 'twilio/sms',                  to: 'twilio#sms'

  # Help
  get 'intro_video',                 to: 'help#intro_video',                 as: 'intro_video'
  get 'dont_onboard',                to: 'help#dont_onboard',                as: 'dont_onboard'
  get 'set_onboarded',               to: 'help#set_onboarded',               as: 'set_onboarded'
  get 'play/view_transcript/:id',             to: 'help#view_transcript',             as: 'view_transcript'

end
