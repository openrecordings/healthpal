Rails.application.routes.draw do

  devise_for :users
  root 'home#index'

  # Admin
  get 'admin',                       to: 'admin#index'	
  get 'users',                       to: 'admin#users'
  get 'toggle_otp/:id',              to: 'admin#toggle_otp',                 as: 'toggle_otp'
  get 'new_registration',            to: 'admin#new_registration'
  get 'set_password',                to: 'admin#set_password'
  get 'create_registration',         to: 'admin#create_registration'
  get 'switch_to_new_user',          to: 'admin#switch_to_new_user'

  # Recording
  get 'record',                      to: 'record#new' 
  post 'upload',                     to: 'record#upload'

  # Playback
  get 'my_recordings',               to: 'play#index'
  get 'play/:id',                    to: 'play#play',                        as: 'play'
  get 'send_audio/:id',              to: 'play#send_audio',                  as: 'send_audio'

end
