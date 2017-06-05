Rails.application.routes.draw do

  root "pages#home"
  get 'pages/home', to: 'pages#home'

# removed for training:
#  resources :recipes

  get 'recipes', to: 'recipes#index'

end
