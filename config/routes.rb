Rails.application.routes.draw do
  resources :locations
  # get 'home/index'

  root 'home#index'
end
