Rails.application.routes.draw do
  root 'posts#index'

  resources :friend_requests, only: [:index, :create, :update, :destroy]
  resources :users, only: [:index, :show]
  resources :posts, only: [:index, :create]

  devise_for :users
end
