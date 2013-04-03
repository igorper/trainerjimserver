Trainerjim::Application.routes.draw do
  
#  devise_for :users
  devise_for :users, :path => '', :path_names => {
    :sign_in => 'login',
    :sign_up => 'register',
    :sign_out => 'logout'
  }

  # NOTE: Mobile API or MAPI means that sessions aren't processed and most
  # privileged actions require explicit authentication (through email/password or
  # Google Token Authentication or otherwise). It will be written in the
  # documentation of provided of the controller's action.

  ##############################################################################
  ### PUBLIC PAGES (html-render
  ##
  # Homepage
  match 'index' => "home#index", :as => :home
  root :to => 'home#welcome', :as => :welcome
  # Dashboard
  match 'dashboard' => 'dashboard#show', :as => :dashboard
  match 'dashboard/statistics/:user' => 'dashboard#statistics'
  match 'dashboard/measurements/:user' => 'dashboard#measurements'
  match 'dashboard/measurement/:id' => 'dashboard#measurement'
  match 'dashboard/series_executions_by_type/:measurement/:exercise' => 'dashboard#series_executions_by_type'
  match 'dashboard/exercise/:measurement/:exercise' => 'dashboard#exercise'
  match 'dashboard/exercisedates/:user' => 'dashboard#exercisedates'
  # Measurements
  match 'measurements/upload' => 'measurements#upload'
  match 'measurements/new' => 'measurements#new'
  match 'measurements/list' => 'measurements#show'
  # MeasuremntComments
  match 'measurements/comment' => 'MeasurementComments#new', :via => :post
  match 'measurements/comment' => 'MeasurementComments#delete', :via => :delete
  # Trainings
  resources :training
  match 'workouts' => 'training#workouts', :as => :workouts
  
  
  
  ##############################################################################
  ### Ajax (e.g., json data requests, other Ajax requests made from the browser;
  ##        authentication is handled through cookies and sessions)
  ##
  # Users
  match 'users/list' => 'users#list'
  # Conversations
  match 'conversations/list/:user' => 'conversations#list'
  
  
  
  ##############################################################################
  ### MOBILE API (these can be called from mobile apps---some of these require
  ##              authentication parameters passed through POST params)
  ##
  # Newsletter
  match 'mapi/subscription/newsletter' => 'home#m_subscribe', :as => :subscription
  # Training
  match 'mapi/training/tests' => 'training#tests'
  match 'mapi/training/get' => 'training#m_get'
  match 'mapi/training/list' => 'training#m_list'
  match 'mapi/training/upload' => 'training#m_upload', :as => :upload_training
end
