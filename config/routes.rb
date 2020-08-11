Rails.application.routes.draw do

  root   'home#top'

  get    '/events', to: 'events#events', as: 'calendar_events'
  get    '/:category_id/calendar/index', to: 'calendar#index', as: 'calendar_index'

  get    '/orders/search', to: 'orders#search', as: 'orders_search'
  get    '/:category_id/orders/:id', to: 'orders#show', as: 'order'
  get    '/:category_id/orders/oil', to: 'orders#oil', as: 'orders_oil'
  get    '/:category_id/order', to: 'orders#new', as: 'new_order'
  post   '/:category_id/order', to: 'orders#create'
  resources :orders, except: [:new, :create, :show]

  get    '/:category_id/constructions/:id', to: 'constructions#show', as: 'construction'
  get    '/constructions/search', to: 'constructions#search', as: 'constructions_search'
  get    '/:category_id/construction', to: 'constructions#new', as: 'new_construction'
  post   '/:category_id/construction', to: 'constructions#create'
  resources :constructions, except: [:new, :create, :show]

  get    '/facility', to: 'facilities#new', as: 'facility'
  post   '/facility', to: 'facilities#create', as: 'facilities'

  get    '/login',    to: 'sessions#new'
  post   '/login',    to: 'sessions#create'
  delete '/logout',   to: 'sessions#destroy'

  get   '/signup',  to: 'users#new', as: 'signup'
  post  '/signup',  to: 'users#create'
  resources :users, except: [:new, :create]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
