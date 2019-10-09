Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'homepages#index'

  resources :drivers 

  resources :passengers
  
  resources :trips, except: [:index]
end
