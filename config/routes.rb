Rails.application.routes.draw do
  resources :head_lists
  get 'user_logs/index'
  resources :bills
  resources :statements
  resources :bill_lists
  resources :users 
  resources :rents
  
  resources :rooms
  resources :halls
  resources :user_logs, only: [:index]
  
  get '/bills/:id/preview', to: 'bills#preview', as: 'preview_bill'
  get '/bills/:id/download', to: 'bills#download', as: 'download_bill'
  get 'preview', to: 'bills#preview'
  get 'download', to: 'bills#download'
  get '/bill_form_partial', to: 'bills#bill_form_partial'
  get '/get_rent_user_info', to: 'rents#get_rent_user_info'
  patch '/bills/:id', to: 'bills#update', as: 'update_bill'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
