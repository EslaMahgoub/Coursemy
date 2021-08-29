Rails.application.routes.draw do
  devise_for :users
  resources :courses
  root "home#index"
  #get 'static_pages/landing_page'
  #get 'static_pages/privacy_policy'
  #get 'privacy_policy', to: "static_pages#privacy_policy" 
  get "privacy_policy", to: "home#privacy_policy"
  
end
