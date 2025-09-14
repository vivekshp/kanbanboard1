Rails.application.routes.draw do
  get "invites/index"
  get "invites/update"
  get "invites/destroy"
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
    resources :members, controller: 'board_members', only: [:index, :create, :update, :destroy]
    resources :lists, only: [:index, :show, :create, :update, :destroy] do
      resources :tasks, only: [:index, :show, :create, :update, :destroy] do
        resources :task_assignments, only: [:create, :destroy]
      end
    end
  end

  get 'users/search', to: 'users#search'
 get 'users/search_board_members', to: 'users#search_board_members'
 get "search", to: "search#index"

get 'assignees', to: 'assignees#index'
get 'histories', to: 'histories#index'



  resources :invites, only: [:index, :update, :destroy]


end
