Rails.application.routes.draw do
  root "dashboard#index"
  resources :sales_entries, only: [:create, :update]
  
  get 'orders', to: 'dashboard#index' # Placeholder
  get 'inventory', to: 'dashboard#index' # Placeholder
  get 'analytics', to: 'analytics#index'
  get 'settings', to: 'dashboard#index' # Placeholder
end
