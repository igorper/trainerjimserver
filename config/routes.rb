Trainerjim::Application.routes.draw do

  root :to => 'index#index', :as => :welcome

  namespace :api do
    namespace :v1 do
      namespace :auth do
        post 'login'
        post 'logout'
        post 'signup'
        get 'is_logged_in'
      end

      resources :trainings, :exercise_types, :exercise_groups

      # START: Users
      resources :users do
        post 'confirm', on: :collection
        post 'confirm_user_details', on: :collection
        post 'name', on: :member
        post 'password', on: :member
        get 'current', on: :collection
      end
      # END: Users

      # START: Measurements
      resources :measurements do
        get 'detailed_measurements', on: :collection
      end
      get 'users/:user_id/measurements', to: 'measurements#user_measurements'
      get 'users/:user_id/detailed_measurements', to: 'measurements#detailed_user_measurements'
      # END: Measurements

      # START: Dashboard
      namespace :dashboard do
        get :rating_counts
        get :monthly_overview
        get :total_rest
        get :planned_rest
      end
      # END: Dashboard

      # START: User Exercise Type Photos
      get 'users/:user_id/exercise_photos', to: 'user_exercise_photos#user_exercise_photos'
      get 'users/:user_id/trainings/:training_id/exercise_photos', to: 'user_exercise_photos#user_training_photos'
      get 'users/exercise_types/:exercise_type_id/photos', to: 'user_exercise_photos#photos_of_current_user'
      get 'users/exercise_types/primary_photos', to: 'user_exercise_photos#primary_photos'
      get 'users/:user_id/exercise_types/:exercise_type_id/photos', to: 'user_exercise_photos#photos_of_user_and_exercise_type'
      post 'users/:user_id/exercise_types/:exercise_type_id/photos', to: 'user_exercise_photos#add_photo'
      delete 'user_exercise_photos/:id', to: 'user_exercise_photos#destroy'
      # END: User Exercise Type Photos

      resources :trainees do
        post 'photo', on: :member
        resources :trainings, controller: 'trainees/trainee_trainings'
      end
    end
  end

  ##############################################################################
  ### AUTHENTICATION
  ##
  devise_for :users, :path => '', :path_names => {
                       :sign_in => '/',
                       :sign_up => '/',
                       :sign_out => '/',
                       :registration => '/',
                       :confirmation => '/'
                   }

end
