Rails.application.routes.draw do

  devise_for :users

  root 'home#index'

  resources :recordings

  resources :utterances do
    get 'set_tag/:name',             to: 'utterances#set_tag', :val => true
    get 'unset_tag/:name',           to: 'utterances#set_tag', :val => false
  end

  resources :user_fields_recording do
    collection do
      put 'update'
    end
  end

  # Admin
  get 'admin',                       to: 'admin#index'
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
  get 'recording_saved',             to: 'record#saved'

  # Playback
  get 'my_recordings',               to: 'play#index',                       as: 'my_recordings'
  get 'play/:id',                    to: 'play#play',                        as: 'play'
  get 'play/send_audio/:id',              to: 'play#send_audio',                  as: 'send_audio'

  # Sharing
  resources :shares, controller: :share
  get 'no_shares',                   to: 'share#no_shares',                   as: 'no_shares'
end
