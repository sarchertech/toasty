Toasty::Application.routes.draw do
  resources :accounts
  
  resources :salons, :constraints => {:subdomain => /.+/} do
    resources :beds
    resources :customers
    resources :users, :path => 'employees'
    resources :tan_sessions
    resources :customer_tan_sessions
    match '/customer_login' => 'customer_session#new', :as => 'new_customer_login', :via => :get, 
                                   :constraints => {:subdomain => /.+/}
    match '/customer_login' => 'customer_session#create', :as => 'customer_login', :via => :post, 
                                      :constraints => {:subdomain => /.+/}

    match '/customer_logout' => 'customer_session#destroy', :as => 'customer_logout', :via => :delete, 
                                     :constraints => {:subdomain => /.+/}
  end

  resources :customers, :constraints => {:subdomain => /.+/}
  resources :users, :constraints => {:subdomain => /.+/}

  match '/salons/:salon_id/customer_search' => 'customer_search#create', 
    :as => 'customer_search', :via => :post

  match '/salons/:salon_id/customer_json_search' => 'customer_json_search#create', 
    :as => 'customer_json_search', :via => :post

  match '/login' => 'session#new', :as => 'new_login', :via => :get, 
                                   :constraints => {:subdomain => /.+/}

  match '/login' => 'session#create', :as => 'login', :via => :post, 
                                      :constraints => {:subdomain => /.+/}

  match '/logout' => 'session#destroy', :as => 'logout', :via => :delete, 
                                     :constraints => {:subdomain => /.+/}

  match '/change_password' => 'employee_password#edit',
    :as => 'edit_password', :via => :get
  
  match '/change_password' => 'employee_password#update',
    :as => 'change_password', :via => :put 

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
