Trainerjim::Application.routes.draw do
  
  # NOTE: Mobile API or MAPI means that sessions aren't processed and most
  # privileged actions require explicit authentication (through email/password or
  # Google Token Authentication or otherwise). It will be written in the
  # documentation of provided of the controller's action.

  # Homepage
  match 'index' => "home#index", :as => :home
  root :to => 'home#soon', :as => :soon
  
  # Login
  match "login" => 'authentication#login', :as => :login
  match "logout" => 'authentication#logout', :as => :logout
  match "register" => 'authentication#register', :as => :register
  # AJAX API:
  post "authentication/authenticate", :as => :authenticate
  post "authentication/create_user", :as => :create_user
  
  # Dashboard
  match 'dashboard' => 'dashboard#show', :as => :dashboard
  match 'dashboard/statistics/:user' => 'dashboard#statistics'
  match 'dashboard/measurements/:user' => 'dashboard#measurements'
  match 'dashboard/measurement/:id' => 'dashboard#measurement'
  match 'dashboard/series_executions_by_type/:measurement/:exercise' => 'dashboard#series_executions_by_type'
  match 'dashboard/exercise/:measurement/:exercise' => 'dashboard#exercise'
  match 'dashboard/knockout' => 'dashboard#knockout'
  match 'dashboard/exercisedates/:user' => 'dashboard#exercisedates'
  
  #Users
  match 'users/list' => 'users#list'
  
  # Measurements
  match 'measurements/upload' => 'measurements#upload'
  match 'measurements/new' => 'measurements#new'
  match 'measurements/list' => 'measurements#show'
  
  # Trainings
  resources :training
  match 'mapi/training/tests' => 'training#tests'
  # MOBILE API
  match 'mapi/training/get' => 'training#m_get'
  match 'mapi/training/list' => 'training#m_list'
  match 'mapi/training/upload' => 'training#m_upload', :as => :upload_training

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
