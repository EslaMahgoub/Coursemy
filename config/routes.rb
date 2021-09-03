Rails.application.routes.draw do
  resources :enrollments do
    get :my_students, on: :collection
  end
  devise_for :users   
  resources :users, only: %i[ index edit show update ] # resources :users, must be after devise_for :users to prevent redirecting loops
  resources :courses do
    get :purchased, :pending_review, :created, on: :collection
    resources :lessons
    resources :enrollments, only: %i[ new create ]
  end
  get 'home/index'
  get "activity", to: "home#activity"
  get "privacy_policy", to: "home#privacy_policy"
  root "home#index"
  #get 'static_pages/privacy_policy'
end
