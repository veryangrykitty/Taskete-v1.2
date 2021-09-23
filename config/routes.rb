Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "pages#home"

  get '/dashboard', to: "dashboard#index", as: :dashboard

  resources :workflows, only: [:create]
  resources :items, only: [:index, :new, :create]
end
