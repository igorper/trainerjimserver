class Api::V1::QueriesController < ActionController::Base

  def general_query
    QueriesMailer
        .general_query(params[:email], params[:message])
        .deliver_later
  end

end