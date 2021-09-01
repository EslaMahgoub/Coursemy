Rails.application.routes.draw do
  devise_for :users  
  resources :users, only: [:index, :edit, :show, :update] # resources :users, must be after devise_for :users to prevent redirecting loops
  resources :courses do
    resources :lessons
  end
  get 'home/index'
  get "home/activity"
  get "privacy_policy", to: "home#privacy_policy"
  root "home#index"
  #get 'static_pages/privacy_policy'
end
