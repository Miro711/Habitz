# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  
  get("/", to: "pages#home", as: :root)

  resources :habits

  resources :users, only: [ :new, :create]
  
  resource :session, only: [ :new, :create, :destroy]

end
