Rails.application.routes.draw do
  get 'albums/index'
  root to: "albums#index"
end
