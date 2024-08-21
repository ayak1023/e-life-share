Rails.application.routes.draw do

  devise_for :users
  root to: "homes#top"
  get 'about', to: 'homes#about', as: :about
  get 'mypage', to: 'users#mypage', as: :mypage
  get "search" => "searches#search"

  resources :users, only: [:show, :edit, :update, :destroy]
  resources :posts, only: [:new, :create, :index, :show, :edit, :update, :destroy]

  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end

  resources :posts, only: [:new, :create, :index, :show, :destroy] do
    resources :comments, only: [:create, :destroy]
  end

end
