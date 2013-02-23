module AjaxHelper
    def ajax_error(msg, id, attributes = nil)
      res = {:message => msg, :error_id => id, :error => :ajax_error}
      if attributes.class == Hash
        return attributes.merge res
      else
        return res
      end
    end
    
    def ajax_render(response, i18n_prefix = nil)
      if response.is_a?(Symbol) then
        response = ajax_error(i18n_prefix.nil? ? response : (t i18n_prefix.blank? ? response : "#{i18n_prefix}.#{response}"), response)
      end
      render :json => response
    end
end
