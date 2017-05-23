Rails.application.routes.draw do


  resources :friend_requests, only: [:create, :update, :destroy]
  #resources :users

  devise_for :users
end
