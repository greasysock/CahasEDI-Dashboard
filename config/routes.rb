Rails.application.routes.draw do
  devise_for :users
  root 'page#home'
  get 'invoices', to: 'page#invoices'
  get 'messages', to: 'page#messages'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
