class TrainingController < ApplicationController
  
  include AjaxHelper
  include TrainingHelper
  
  def workouts
  end
  
  def show
    @t = Training.find_by_id(params[:id])
  end
  
  # Returns an entire training for the user.
  # @method POST, GET
  # @param email 
  # @param password
  # @param id
  # @returns JSON a JSON encoded string containing the first training (together
  # with its exercises and series).
  def m_get
    with_auth_mapi do |user|
      ajax_render Training.find_by_id(params[:id], :include => [:exercises, {:exercises => :series}]).to_json(TrainingHelper.training_full_view)
    end
  end
  
  # Lists all trainings for the current user
  # @method POST, GET
  # @param email 
  # @param password
  # @returns JSON a JSON encoded list all trainings
  def m_list
    with_auth_mapi do |user|
      ajax_render Training.all.to_json(TrainingHelper.training_view)
    end
  end
  
  # @param email
  # @param password
  # @param trainingId
  # @param trainingData [ZIP FILE] a binary stream of data.
  # TODO: define ZIP FILE contents.
  def m_upload
    with_auth_mapi do |user|
      require 'zip/zipfilesystem'
      # Get the zip file that is the training data:
      Zip::ZipFile.open(params[:trainingData].path) do |zip_file|
        
        data = []
        
        zip_file.each do |file|
          data.push({:name => file.name, :size => file.size, :compressed_size => file.compressed_size})
        end
        
        ajax_render data
      end
    end
  end
  
  def tests
    ajax_render clone_training_for_user(Training.find_by_id(1, :include => [:exercises, {:exercises => [:series, :exercise_type]}]), User.find_by_email('matej.urbas@gmail.com')).to_json(TrainingHelper.training_full_view)
#    ajax_render Training.find_by_id(1, :include => [:exercises, {:exercises => [:series, :exercise_type]}]).to_json(TrainingHelper.training_full_view)
  end
end
