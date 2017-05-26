Rails.application.routes.draw do
  root 'posts#index'

  devise_for :users
  resources :friend_requests, only: [:index, :create, :update, :destroy]
  resources :users, only: [:index, :show]
  resources :posts, only: [:index, :create] do
    resources :likes, only: [:create]
  end
  resources :comments, only: [:create] do
    resources :likes, only: [:create]
  end

  resources :profile, only: [:edit, :update]
end
