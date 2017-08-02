Rails.application.routes.draw do

  devise_for :users
  root 'home#index'

  # Admin
  get 'admin',                       to: 'admin#index'	
  get 'users',                       to: 'admin#users'
  get 'toggle_otp/:id',              to: 'admin#toggle_otp',                 as: 'toggle_otp'

  # Recording
  get 'record',                      to: 'record#new' 
  post 'upload',                     to: 'record#upload'

  # Playback
  get 'play',                        to: 'play#play' 
  get 'send_audio',                  to: 'play#send_audio'

end
