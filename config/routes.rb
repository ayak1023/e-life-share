Rails.application.routes.draw do

  devise_for :admin, skip: [:registrations, :password], controllers: {
    sessions: 'admin/sessions'
  }

  namespace :admin do
    get 'dashboards', to: 'dashboards#index'
    resources :users, only: [:destroy]
  end

  devise_for :users
  root to: "homes#top"
  get 'about', to: 'homes#about', as: :about
  get 'mypage', to: 'users#mypage', as: :mypage
  get "search" => "searches#search"

  resources :users, only: [:index, :show, :edit, :update, :destroy] do
    # ユーザーのフォロワー、フォロー関係
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'

    # お気に入り
    member do
      get :favorites
    end
  end


  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end


  resources :posts, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
    resources :comments, only: [:create, :destroy]
    resource :favorite, only: [:create, :destroy]
  end

end
