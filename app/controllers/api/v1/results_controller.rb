class Api::V1::ResultsController < ActionController::Base

  include ResultsHelper

  def index
    if user_signed_in?
      @results_list = Measurement.where(trainee_id: current_user.id)
    else
      render status: :unauthorized
    end
  end
end