FarHorizonsApp::Application.routes.draw do
  
  # Not associated with a model, so needs explicit route
  get 'track_example' => 'track_example#index'
  
  get 'tracking_home' => 'tracking_home#index'
  
  resources :tracking_home
  
  resources :sky_tracks

  resources :routers

  resources :predicted_tracks

  resources :points

  resources :platform_servers

  resources :platforms

  resources :missions

  resources :location_devices

  resources :ground_tracks

  resources :chase_vehicles

  resources :chase_servers

  resources :beacon_transmitters

  resources :beacon_receivers

  resources :beacons
  
  post 'location_devices/start/:id' => 'location_devices#start'
  post 'location_devices/stop/:id' => 'location_devices#stop'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

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
