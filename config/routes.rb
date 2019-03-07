Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}
  root 'page#home'

  resources :messages, except: [:destroy, :edit, :update]
  resources :invoices, except: [:destroy, :edit, :update]
  resources :purchase_orders, except: [:destroy, :edit, :update]
  resources :partnerships, except: [:destroy, :edit, :update]
  #resources :admin_dashboard, only: [:index]
  namespace :admin do
    get '/', to: 'admin_dashboard#index'

    post 'new_user', to: 'admin_dashboard#create_user'
    get 'new_user', to: 'admin_dashboard#new_user'

    delete ':id/edit_user', to: 'admin_dashboard#destroy_user', as: 'destroy_user'
    get ':id/edit_user', to: 'admin_dashboard#edit_user', as: 'edit_user'
    put ':id/edit_user', to: 'admin_dashboard#update_user'
    resources :users, only: [:index]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
