Rails.application.routes.draw do

  root   'home#top'

  get    '/events_index', to: 'events#index', as: 'events_index'
  get    '/events_show', to: 'events#show', as: 'events_show'
  get    '/calendar/index', to: 'calendar#index', as: 'calendar_index'
  get    '/calendar/show', to: 'calendar#show', as: 'calendar_show'

  get    '/orders/search', to: 'orders#search', as: 'orders_search'
  get    '/orders/oil', to: 'orders#oil', as: 'orders_oil'
  resources :orders

  resources :comments, only: [:create, :edit, :update, :destroy]

  get    '/constructions/search', to: 'constructions#search', as: 'constructions_search'
  resources :constructions

  get    '/facility', to: 'facilities#new', as: 'facility'
  post   '/facility', to: 'facilities#create', as: 'facilities'

  post   '/guest_login',    to: 'guest_sessions#create'

  get    '/login',    to: 'sessions#new'
  post   '/login',    to: 'sessions#create'
  delete '/logout',   to: 'sessions#destroy'

  patch '/users/:id',  to: 'users#update', as: 'update_user'
  get   '/signup',  to: 'users#new', as: 'signup'
  post  '/signup',  to: 'users#create'
  resources :users, except: [:new, :create]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
