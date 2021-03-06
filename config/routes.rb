Rails.application.routes.draw do
  resources :enrollments do
    get :my_students, on: :collection
    member do
      get :certificate
    end
  end
  
  devise_for :users, :controllers => {registrations: 'users/registrations', omniauth_callbacks: 'users/omniauth_callbacks'}
  resources :users, only: %i[ index edit show update ] # resources :users, must be after devise_for :users to prevent redirecting loops
  resources :tags, only: %i[create index destroy]
  resources :courses, except: [:edit] do
    get :purchased, :pending_review, :created, :unapproved, on: :collection
    member do 
      # Add two new actions to our routes
      get :analytics
      patch :approve
      patch :unapprove
    end
    resources :lessons, except: [:index] do
      resources :comments, except: [:index]
      put :sort 
      member do
        delete :delete_video
      end
    end
    resources :enrollments, only: %i[ new create ]
    resources :course_wizard, controller: 'courses/course_wizard'
  end
  
  resources :youtube, only: :show
  
  
  get 'home/index'
  get "activity", to: "home#activity"
  get "analytics", to: "home#analytics"
  get "privacy_policy", to: "home#privacy_policy"
  root "home#index"
  
  
  # Charts Routes
  # get "charts/users_per_day", to: "charts#users_per_day"
  # get "charts/enrollments_per_day", to: "charts#enrollments_per_day"
  # get "charts/course_popularity", to: "charts#course_popularity"
  # get "charts/most_paid_courses", to: "charts#most_paid_courses"
  namespace :charts do
    get 'users_per_day'
    get 'enrollments_per_day'
    get 'course_popularity'
    get 'most_paid_courses'
  end
end
