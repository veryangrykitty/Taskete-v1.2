Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "pages#home"

  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  get '/dashboard', to: "dashboard#index", as: :dashboard
  get '/my_tasks', to: 'dashboard#my_tasks', as: :my_tasks

  resources :workflows, only: [:create, :show, :update] do
    resources :tasks, only: [:index, :show]
    member do
      get :completion
    end
  end

  put '/activate', to: 'workflows#activate', as: :activate
  # post '/workflows_tabs', to: 'workflows#tabs', as: :workflow_tabs

  resources :tasks, only: [:index, :new, :create, :destroy, :update] do
    resources :items, only: [:new]
    resources :task_members, only: [:create]
    member do
      get :completed
    end
  end

  resources :task_members, only: [:new]

  resources :items, only: [:index, :create, :show, :destroy] do
    member do
      patch :move
    end
  end

end
