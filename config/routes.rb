Rails.application.routes.draw do

  root 'home#top'

  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  resources :users, except: [:new, :create]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
