Rails.application.routes.draw do
  resources :bills
  resources :statements
  resources :bill_lists
  resources :rents
  resources :users
  resources :rooms
  resources :halls

  get '/bill_form_partial', to: 'bills#bill_form_partial'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
