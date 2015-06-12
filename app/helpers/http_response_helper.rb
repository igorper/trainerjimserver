module HttpResponseHelper

  def render_unauthorized
    render 'api/v1/http_responses/unauthorized', status: :unauthorized
  end

  def render_forbidden
    render 'api/v1/http_responses/forbidden', status: :forbidden
  end

  def render_not_found
    render 'api/v1/http_responses/not-found', status: :not_found
  end

end
