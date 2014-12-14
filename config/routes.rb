Trainerjim::Application.routes.draw do

  ##############################################################################
  ### Pages
  ##
  get 'welcome' => 'web/welcome#welcome', :as => :web_welcome

  ##############################################################################
  ### AUTHENTICATION
  ##
  devise_for :users, :path => '', :path_names => {
    :sign_in => 'login',
    :sign_up => 'signup',
    :sign_out => 'logout',
    :registration => 'register'
  }

  ##############################################################################
  ### PUBLIC PAGES
  ##
  # Home
  root :to => 'home#welcome', :as => :welcome
  # Dashboard
  get 'dashboard' => 'dashboard#show', :as => :dashboard
  # Training
  get 'workouts' => 'training#workouts', :as => :workouts
  # Development stuff
  get 'training/tests' => 'training#tests'  
  # Trainees
  get "users/trainees"
  
  
  ##############################################################################
  ### Ajax (e.g., json data requests, other Ajax requests made from the browser;
  ##        authentication is handled through cookies and sessions)
  ##
  # Users
  match 'users/list' => 'users#list', :via => [:post, :get]
  match 'users/list_trainees' => 'users#list_trainees', :via => [:post, :get]
  # Conversations
  match 'conversations/list_by_measurement/:measurement' => 'conversations#list_by_measurement', :via => [:post, :get]
  post 'conversations/new/' => 'conversations#new'
  # Measurement comments
  post 'measurements/comment' => 'measurements/comments#new'
  match 'measurements/comment' => 'measurements/comments#delete', :via => :delete
  # Dashboard
  match 'dashboard/statistics/:user' => 'dashboard#statistics', :via => [:post, :get]
  match 'dashboard/measurements/:user' => 'dashboard#measurements', :via => [:post, :get]
  match 'dashboard/measurement/:id' => 'dashboard#measurement', :via => [:post, :get]
  match 'dashboard/series_executions_by_type/:measurement/:exercise' => 'dashboard#series_executions_by_type', :via => [:post, :get]
  match 'dashboard/exercise/:measurement/:exercise' => 'dashboard#exercise', :via => [:post, :get]
  match 'dashboard/exercisedates/:user' => 'dashboard#exercisedates', :via => [:post, :get]
  # Training and workouts
  match '/training/templates' => 'training#templates', :via => [:post, :get]
  match '/training/my_templates' => 'training#my_templates', :via => [:post, :get]
  match '/training/my_template' => 'training#my_template', :via => [:post, :get]
  match '/training/exercise_types' => 'training#exercise_types', :via => [:post, :get]
  match '/training/save_workout' => 'training#save_workout', :via => [:post, :get]
  match '/training/delete_workout' => 'training#delete_workout', :via => [:post, :get]
  # Utils/Assets
  get 'resource' => 'utils/assets#asset'
  
  
  
  ##############################################################################
  ### MOBILE API (these can be called from mobile apps---some of these require
  ##              authentication parameters passed through POST params)
  ##
  # NOTE: Mobile API or MAPI means that sessions aren't processed (no cookies)
  # and most privileged actions require explicit authentication (through
  # email/password or Google Token Authentication or otherwise). It will be
  # written in the documentation of provided of the controller's action.

  # Newsletter
  match 'mapi/subscription/newsletter' => 'home#m_subscribe', :as => :subscription, :via => [:post, :get]
  # Training
  match 'mapi/training/tests' => 'training#tests', :via => [:post, :get]
  match 'mapi/training/get' => 'training#m_get', :via => [:post, :get]
  match 'mapi/training/list' => 'training#m_list', :via => [:post, :get]
  match 'mapi/training/upload' => 'training#m_upload', :as => :upload_training, :via => [:post, :get]
  # Users
  match 'mapi/users/authenticate' => 'users#m_authenticate', :via => [:post, :get]
end
