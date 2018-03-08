Rails.application.routes.draw do
  #root "main#index"
  root "users#recognize"
  get 'main/index'
  resources :users do
    get :recognize, on: :collection
    post :identify, on: :collection
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
