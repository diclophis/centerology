ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end
  #map.resource :person, :member => { :complete => :get }

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "welcome"

  map.login '/login', :controller => "people", :action => "login"
  map.register '/register', :controller => "people", :action => "register"
  map.bookmarklet '/bookmarklet', :controller => "welcome", :action => "bookmarklet"
  map.cloud '/cloud', :controller => "welcome", :action => "cloud"
  map.random '/random', :controller => "welcome", :action => "random"
  map.random '/plist_of_images_to_rate', :controller => "welcome", :action => "plist_of_images_to_rate"

  map.philosophy '/philosophy', :controller => "welcome", :action => "philosophy"
  map.findings '/findings', :controller => "welcome", :action => "findings"
  map.image '/image/:permalink', :controller => "welcome", :action => "image"
  map.similarities '/similarities/:permalink', :controller => "welcome", :action => "similarities"
  map.feed '/feeds/:nickname', :controller => "welcome", :action => "feed"
  #map.rss_feed '/rss/findings/:tagged', :controller => "welcome", :action => "findings", :format => "rss"
  map.rss_feed '/rss/:nickname', :controller => "welcome", :action => "feed", :format => "rss"

  # See how all your routes lay out with "rake routes"
  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
