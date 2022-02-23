Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        resources :most_items, only: :index
        resources :find, only: :index
      end

      namespace :items do
        resources :find_all, only: :index
      end

      resources :merchants, only: %i[index show]
      resources :items, only: %i[index show create update destroy]
      get '/merchants/:id/items', to: 'merchant_items#index'
      get '/items/:id/merchant', to: 'merchant_by_item#show'
      #get '/merchant', controller: :merchants, action: :show
      namespace :revenue do
        resources :merchants, only: %i[index show]
        get '/unshipped', to: 'unshipped#index'
      end
    end
  end
end
