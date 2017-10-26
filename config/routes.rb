Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  get 'albums/index'
  root to: "albums#index"
end
