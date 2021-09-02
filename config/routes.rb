Rails.application.routes.draw do
  resources :enrollments
  devise_for :users   
  resources :users, only: %i[ index edit show update ] # resources :users, must be after devise_for :users to prevent redirecting loops
  resources :courses do
    resources :lessons
    resources :enrollments, only: %i[ new create ]
  end
  get 'home/index'
  get "activity", to: "home#activity"
  get "privacy_policy", to: "home#privacy_policy"
  root "home#index"
  #get 'static_pages/privacy_policy'
end
