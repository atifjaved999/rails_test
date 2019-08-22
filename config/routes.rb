Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'lists#index'
  
  resources :lists, except: [:show] do
    member do
      post :soft_delete
      post :restore
    end

    collection do
      get :trash
    end
  end

  resources :list_items, only: [:destroy] do
    member do
      post :soft_delete
      post :restore
    end
  end
  
end
