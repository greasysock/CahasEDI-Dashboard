Rails.application.routes.draw do
  devise_for :users
  root 'page#home'

  resources :messages, except: [:destroy, :edit, :update]
  resources :invoices, except: [:destroy, :edit, :update]
  resources :purchase_orders, except: [:destroy, :edit, :update]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
