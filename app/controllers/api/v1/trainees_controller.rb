class Api::V1::TraineesController < ActionController::Base

  def index
    if user_signed_in?
      @trainees = User.where(trainer_id: current_user.id)
    else
      render status: :unauthorized
    end
  end

end