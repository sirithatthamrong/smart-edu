Rails.application.routes.draw do
  resources :attendances
   resources :students do
    collection do
      post 'mark_attendance'
    end
  end
  get "home/index"
  resource :session
  resources :passwords, param: :token
  resources :signup, only: %i[new create]
  resources :users, only: %i[index] do
    member do
      patch :approve
      delete :cancel
    end
  end


  get "/admin/scan_qr", to: "admin#scan_qr"
  post "/admin/checkin", to: "admin#checkin"
  get "/students/scan", to: "admin#scan_qr"
  get "up" => "rails/health#show", as: :rails_health_check
  root "home#index"
end
