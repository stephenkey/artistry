Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, path: '/', path_names: { sign_in: 'login', sign_out: 'logout', password: 'password', confirmation: 'confirmation', unlock: 'unlock', registration: 'account', sign_up: 'register' }

  get 'albums/index'
  root to: "albums#index"
end
