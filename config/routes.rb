Rails.application.routes.draw do
  root 'posts#index'

  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }
  resources :friend_requests, only: [:index, :create, :update, :destroy]
  resources :users, only: [:index, :show]
  resources :posts, only: [:index, :create, :destroy] do
    resources :likes, only: [:create, :destroy]
  end
  resources :comments, only: [:create, :destroy] do
    resources :likes, only: [:create, :destroy]
  end

  resources :profile, only: [:edit, :update]
end
