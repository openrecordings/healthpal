Rails.application.routes.draw do

  devise_for :users
  root 'home#index'

  resources :recordings do
    resources :transcripts
  end
  resources :transcripts
  resources :utterances do
    get 'set_tag/:name',             to: 'utterances#set_tag', :val => true
    get 'unset_tag/:name',           to: 'utterances#set_tag', :val => false
  end

  # Admin
  get 'admin',                       to: 'admin#index'	
  get 'recordings',                  to: 'recordings#index'
  get 'users',                       to: 'admin#users'
  get 'toggle_otp/:id',              to: 'admin#toggle_otp',                 as: 'toggle_otp'
  get 'new_registration',            to: 'admin#new_registration'
  post 'set_password',               to: 'admin#set_password'
  post 'create_registration',        to: 'admin#create_registration'
  get 'switch_to_new_user',          to: 'admin#switch_to_new_user'

  # Recording
  get 'record',                      to: 'record#new' 
  post 'upload',                     to: 'record#upload'
  get 'recording_saved',             to: 'record#saved'

  # Playback
  get 'my_recordings',               to: 'play#index',                       as: 'my_recordings'
  get 'play/:id',                    to: 'play#play',                        as: 'play'
  get 'send_audio/:id',              to: 'play#send_audio',                  as: 'send_audio'

end
