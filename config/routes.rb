Rails.application.routes.draw do
  devise_for :users
  resources :courses
  resources :users, only: [:index]
  get "home/activity"
  get "privacy_policy", to: "home#privacy_policy"
  root "home#index"
  #get 'static_pages/privacy_policy'
end
