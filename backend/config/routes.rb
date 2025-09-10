Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
     
  # Authentication routes
  post 'auth/register', to: 'authentication#register'
  post 'auth/login', to: 'authentication#login'
  delete 'auth/logout', to: 'authentication#logout'
  get 'auth/me', to: 'authentication#me'

  resources :boards, only: [:index, :show, :create, :update, :destroy] do
    resources :lists, only: [:index, :show, :create, :update, :destroy] do
      resources :tasks, only: [:index, :show, :create, :update, :destroy]
    end
  end



end
