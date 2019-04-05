Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get("/", to: "pages#home", as: :root)

  resources :habits
  
  resources :users, only: [ :new, :create ]
  
  resource :session, only: [ :new, :create ] do
    delete :destroy, on: :collection
  end

end
