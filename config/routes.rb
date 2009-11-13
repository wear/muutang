ActionController::Routing::Routes.draw do |map|
  map.resources :skills

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  
  map.resource :session
  map.resources :users, :collection => {:forgot_password => :get,:reset_password => :put ,:auto_complete_for_user_email => :get } ,
            :member => {:posts => :get,:comments => :get,:change_password => :get,:update_password => :put} do |user|
    user.resource :profile
    user.resources :skills
  end
  
  map.resources :posts,:has_many => :comments
  
  map.admin '/admin', :controller => 'admin', :action => 'index'  
   
  map.namespace :admin do |admin|
      # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
      admin.resources :posts,:member => {:marktop => :put,:set_visibility => :put} 
      admin.resources :comments
      admin.resources :categories 
      admin.resources :roles
      admin.resources :users,:member => {:setting_role => :get,:update_role => :put,:destroy_role => :delete }
  end

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

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "landing"
  map.intro '/intro', :controller => 'landing', :action => 'intro' 
#  map.import '/import', :controller => 'landing', :action => 'import'
  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
