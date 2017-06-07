Rails.application.routes.draw do

  devise_for :users
  root 'home#index'

  # Admin
  get 'admin',                       to: 'admin#index'	
  get 'users',                       to: 'admin#users'
  get 'toggle_otp/:id',              to: 'admin#toggle_otp',                 as: 'toggle_otp'

  # Recording
  post 'upload',                      to: 'home#upload'

end
