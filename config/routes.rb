Rails.application.routes.draw do
  resources :classrooms, only: [ :index, :show ]

  resources :classrooms do
    collection do
      get "by_grade/:grade", to: "classrooms#by_grade", as: "by_grade"
      end
    member do
      get :grading
      get :grade_level
    end
    resources :students, only: [ :index, :show ]
  end
  resources :attendances
  get "home/index"
  resource :session
  resources :passwords, param: :token
  resources :signup, only: %i[new create]
  resources :students
  resources :users, only: %i[index] do
    member do
      patch :approve
      delete :cancel
    end
  end
  get "up" => "rails/health#show", as: :rails_health_check
  root "home#index"
  resources :students do
    member do
      patch :toggle_status
      patch :archive
      patch :activate
    end
    collection do
      get :manage  # This will map to students#manage
    end
  end
  get "classrooms/:id/grades/:grade", to: "classrooms#grading", as: :grading_by_grade
  get "grades/:grade", to: "classrooms#by_grade", as: :grade
end
