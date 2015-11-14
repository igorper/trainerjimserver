class Api::V1::QueriesController < ActionController::Base

  include HttpResponseHelper

  def general_query
    if ValidateEmail.valid?(params[:email])
      QueriesMailer
          .general_query(params[:email], params[:message])
          .deliver_later
    else
      render_bad_request
    end
  end

end