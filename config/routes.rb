# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      
      get("/habits/index_public", to: "habits#index_public", as: :index_public)
      resources :habits do
        resources :tackled_habits, only: [:create, :destroy]
      end
      
      resource :session, only: [:create, :destroy]
      
      resources :users, only: [:create] do
        get :current, on: :collection
      end

    end
  end
  
  get("/", to: "pages#home", as: :root)

  get("/habits/index_public", to: "habits#index_public", as: :index_public)
  resources :habits do 
    resources :tackled_habits, only: [:create, :destroy]
  end

  resources :users, only: [ :new, :create]
  
  resource :session, only: [ :new, :create, :destroy]

end
