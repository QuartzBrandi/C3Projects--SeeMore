Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  get '/search', to: 'home#search'

  get '/refresh_ig', to: 'ig_subscriptions#refresh_ig'
  get '/refresh_twi', to: 'twi_subscriptions#refresh_twi'

  post "/auth/:provider/callback", to: "sessions#create"
  get '/auth/:provider/callback', to: 'sessions#create'

  delete '/logout', to: "sessions#destroy", as: "logout"

  resources :twi_subscriptions, path: "twitter_results"

  resources :ig_subscriptions, path: "instagram_results"

  get "posts/:id", to: "posts#show", as: "posts"

  get 'home/subscriptions', to: 'home#subscriptions', as: "subscriptions"

  delete 'home/subscription', to: 'home#unfollow', as: 'unfollow'




  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
