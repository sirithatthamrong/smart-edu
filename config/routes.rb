Rails.application.routes.draw do
  resources :attendances
  resources :students
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


end

