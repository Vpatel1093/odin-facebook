Rails.application.routes.draw do


  resources :friend_requests, only: [:index, :create, :update, :destroy]
  resources :users, only: [:index, :show]

  devise_for :users
end
