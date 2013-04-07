Trainerjim::Application.routes.draw do
  
  ##############################################################################
  ### AUTHENTICATION
  ##
  devise_for :users, :path => '', :path_names => {
    :sign_in => 'login',
    :sign_up => 'register',
    :sign_out => 'logout'
  }

  ##############################################################################
  ### PUBLIC PAGES
  ##
  # Home
  root :to => 'home#welcome', :as => :welcome
  # Dashboard
  match 'dashboard' => 'dashboard#show', :as => :dashboard
  # Training
  match 'workouts' => 'training#workouts', :as => :workouts
  # Development stuff
  match 'training/tests' => 'training#tests'
  
  
  
  ##############################################################################
  ### Ajax (e.g., json data requests, other Ajax requests made from the browser;
  ##        authentication is handled through cookies and sessions)
  ##
  # Users
  match 'users/list' => 'users#list'
  match 'users/list_trainees' => 'users#list_trainees'
  # Conversations
  match 'conversations/list_by_measurement/:measurement' => 'conversations#list_by_measurement'
  match 'conversations/new/' => 'conversations#new', :via => :post
  # Measurement comments
  match 'measurements/comment' => 'MeasurementComments#new', :via => :post
  match 'measurements/comment' => 'MeasurementComments#delete', :via => :delete
  # Dashboard
  match 'dashboard/statistics/:user' => 'dashboard#statistics'
  match 'dashboard/measurements/:user' => 'dashboard#measurements'
  match 'dashboard/measurement/:id' => 'dashboard#measurement'
  match 'dashboard/series_executions_by_type/:measurement/:exercise' => 'dashboard#series_executions_by_type'
  match 'dashboard/exercise/:measurement/:exercise' => 'dashboard#exercise'
  match 'dashboard/exercisedates/:user' => 'dashboard#exercisedates'
  # Training stuff
  match '/training/templates' => 'training#templates'
  match '/training/my_templates' => 'training#my_templates'
  match '/training/my_template' => 'training#my_template'
  
  
  
  ##############################################################################
  ### MOBILE API (these can be called from mobile apps---some of these require
  ##              authentication parameters passed through POST params)
  ##
  # NOTE: Mobile API or MAPI means that sessions aren't processed (no cookies)
  # and most privileged actions require explicit authentication (through
  # email/password or Google Token Authentication or otherwise). It will be
  # written in the documentation of provided of the controller's action.

  # Newsletter
  match 'mapi/subscription/newsletter' => 'home#m_subscribe', :as => :subscription
  # Training
  match 'mapi/training/tests' => 'training#tests'
  match 'mapi/training/get' => 'training#m_get'
  match 'mapi/training/list' => 'training#m_list'
  match 'mapi/training/upload' => 'training#m_upload', :as => :upload_training
end
