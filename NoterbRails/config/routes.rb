Rails.application.routes.draw do
  root 'home#index'
  get '/notes/export_all', to: 'notes#export_all', as: 'export_all_notes'

  devise_for :users
  resources :notes
  resources :books

  resources :notes do
    member do
      get 'export'
    end
  end
  resources :books do
    member do
      get 'export'
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
