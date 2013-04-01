module AjaxHelper
  # @param string msg The message to be included in the object
  # @param string id An id of the error. It may be used as an identifier for the
  #                  type of error.
  # @param Hash attributes Additional attributes the returned error object
  #             should contain.
  # @returns Hash An object with (at least) three attributes: `message`,
  #               `error_id` and `error`. The attribute `error` is always set to
  #               "ajax_error". This may be used on the client to identify with
  #               certainty that an error occurred and that the Ajax call was
  #               not successful.
  def ajax_error(id, msg = nil, attributes = nil)
    res = {:error_id => id, :error => :ajax_error}
    res[:message] = msg if !msg.nil?
    if attributes.class == Hash
      return attributes.merge res
    else
      return res
    end
  end
    
  # If `response` is a symbol then this method renders an exception object as JSON.
  # Otherwise it renders the response object.
  # 
  # @param Hash options may have these options:
  #                     :symbol_error (bool) - indicates whether a symbol `response` should indicate an error.
  #                     :i18n_error (string) - this prefix will be used when fetching the localised string based on the error-symbol (this option implies :symbol_error `true`). If not given on `nil`, then no internationalization will be applied
  def ajax_render(response, options = {})
    if (options[:symbol_error] || !options[:i18n_error].nil?) && response.is_a?(Symbol) then
      i18n_prefix = options[:i18n_error]
      render :json => ajax_error(response, i18n_prefix.nil? ? nil : (t i18n_prefix.blank? ? response : "#{i18n_prefix.to_s}.#{response}")), :status => 400
    else
      render :json => response
    end
  end
  
  def ajax_render_symerr(response, i18n_prefix = nil, options = {})
    ajax_render response, options.merge({:symbol_error => true, :i18n_error => i18n_prefix.nil? ? nil : i18n_prefix}) 
  end
  
  def with_auth_mapi(&block)
    user = AuthenticationHelper.multi_auth(params)
    if user.is_a?(User) then
      yield user
    else
      ajax_render_symerr :authentication_failure, 'mapi-err'
    end
  end
end
