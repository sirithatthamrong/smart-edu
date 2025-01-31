Rails.application.routes.draw do
  resources :attendances do
    collection do
      get "scan" => "attendances#scan"
      post "scan_create" => "attendances#scan_create"
    end
  end
  resources :students
  get "home/index"
  resource :session
  resources :passwords, param: :token
  resources :signup, only: %i[new create]
  resources :students
  get "up" => "rails/health#show", as: :rails_health_check
  root "home#index"
end
