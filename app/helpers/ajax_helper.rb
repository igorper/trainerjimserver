module AjaxHelper
  def ajax_error(msg, id, attributes = nil)
    res = {:message => msg, :error_id => id, :error => :ajax_error}
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
      response = ajax_error(i18n_prefix.nil? ? response : (t i18n_prefix.blank? ? response : "#{i18n_prefix.to_s}.#{response}"), response)
    end
    render :json => response
  end
  
  def ajax_render_symerr(response, i18n_prefix = nil)
    ajax_render response, :symbol_error => true, :i18n_error => i18n_prefix.nil? ? (controller_name + '.' + action_name) : i18n_prefix
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
