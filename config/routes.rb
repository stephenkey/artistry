Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, path: '/', path_names: { sign_in: 'login', sign_out: 'logout', password: 'password', confirmation: 'confirmation', unlock: 'unlock', registration: 'account', sign_up: 'register' }

  resources :albums do
    get '/search', to: 'albums#search', on: :collection
    get '/mine', to: 'albums#mine', on: :collection
  end

  resources :artists

  root to: "marketing#index"
end
