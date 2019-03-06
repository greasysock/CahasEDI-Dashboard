Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}
  root 'page#home'

  resources :messages, except: [:destroy, :edit, :update]
  resources :invoices, except: [:destroy, :edit, :update]
  resources :purchase_orders, except: [:destroy, :edit, :update]
  resources :partnerships, except: [:destroy, :edit, :update]
  resources :admin_dashboard, only: [:index] do
    member do

    end
end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
