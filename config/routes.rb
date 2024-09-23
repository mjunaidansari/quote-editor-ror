Rails.application.routes.draw do
  root to: "pages#home"

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  devise_scope :user do
    get 'users/verify_otp', to: 'users/sessions#verify_otp', as: :verify_otp
    post 'users/verify_otp', to: 'users/sessions#check_otp'
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :quotes do
    resource :line_item_dates, except: [:index, :show]
  end

  resources :two_factor_auth do
    collection do
      get :show
      post :enable
      post :disable
    end
  end



  # Defines the root path route ("/")
  # root "posts#index"
end
