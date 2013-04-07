module AjaxHelper
  # @param string msg The message to be included in the object
  # @param string id An id of the error. It may be used as an identifier for the
  #                  type of error.
  # @param Hash attributes Additional attributes the returned error object
  #             should contain.
  # @returns Hash An object with (at least) three attributes: `message`,
  #               `error_id` and `error`. The attribute `error` is always set to
  #               "create_error". This may be used on the client to identify with
  #               certainty that an error occurred and that the Ajax call was
  #               not successful.
  def create_error(id, msg = nil, attributes = nil)
    res = {:error_id => id, :error => :create_error}
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
  #                     :force_error (bool)  - indicates that an error should be rendered.
  #                     :symbol_error (bool) - indicates whether a symbol `response` should indicate an error.
  #                     :i18n_prefix (string) - this is used when generating the translation key. This one is used only when :symbol_error is set to `true`.
  #                     :i18n_key (string) - this is the translation key used when generating the error message (if not specified.
  def ajax_render(response, options = {})
    if options[:force_error] || (options[:symbol_error] && response.is_a?(Symbol)) then
      # Get the error translated message:
      t_key = options[:i18n_key]
      if t_key.nil? then
        if options[:symbol_error] && response.is_a?(Symbol) && !options[:i18n_prefix].nil? then
          t_key = options[:i18n_prefix].to_s + '.' + response.to_s
        else
          t_key = nil
        end
      else
        t_key = t_key.to_s
      end
      # Finally render the whole thing:
      render :json => create_error(response, t_key.nil? ? nil : (t t_key)), :status => 400
    else
      render :json => response
    end
  end
  
  def ajax_error(response, i18n_prefix = nil, options = {})
    ajax_render response, options.merge({:force_error => true, :symbol_error => true, :i18n_prefix => i18n_prefix.nil? ? nil : i18n_prefix}) 
  end
  
  def ajax_error_i18n(response, options = {})
    ajax_error response, controller_name + '.' + action_name 
  end
  
  def with_auth_mapi(&block)
    user = AuthenticationHelper.multi_auth(params)
    if user.is_a?(User) then
      yield user
    else
      ajax_error :authentication_failure, 'mapi-err'
    end
  end
end
