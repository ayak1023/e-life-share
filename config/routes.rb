Rails.application.routes.draw do
  get 'users/show'
  get 'users/edit'
  devise_for :users
  root to: "homes#top"
  get 'about', to: 'homes#about', as: :about

  resources :users, only: [:show, :edit]
end
