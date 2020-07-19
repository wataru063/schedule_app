Rails.application.routes.draw do

  root   'home#top'

  get    '/:category_id/construction', to: 'constructions#new', as: 'construction'
  post   '/:category_id/construction', to: 'constructions#create', as: 'constructions'

  get    '/facility', to: 'facilities#new', as: 'facility'
  post   '/facility', to: 'facilities#create', as: 'facilities'

  get    '/login',    to: 'sessions#new'
  post   '/login',    to: 'sessions#create'
  delete '/logout',   to: 'sessions#destroy'

  get   '/signup',  to: 'users#new', as: 'signup'
  post  '/signup',  to: 'users#create'
  resources :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
