Rails.application.routes.draw do
  root to: "pages#home"
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :quotes do
    resource :line_item_dates, except: [:index, :show]
  end

  resources :two_factor_auth, only: [:show] do
    post :enable, on: collection
    post :disable, on: collection
  end

  get 'users/verify_otp', to: 'users/sessions#verify_otp', as: :verify_otp
  get 'users/verify_otp', to: 'users/sessions#check_otp'

  # Defines the root path route ("/")
  # root "posts#index"
end
