Rails.application.routes.draw do
  root "dashboard#index"
  resources :sales_entries, only: [:create, :update]
  
  get 'analytics', to: 'analytics#index'
  get 'inventory', to: 'dashboard#index' # Placeholder
  get 'settings', to: 'dashboard#index' # Placeholder
  patch 'settings/update_methods', to: 'users#update_methods', as: :update_methods
end
