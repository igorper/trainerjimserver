//= require jquery
//= require jquery-ui
//= require_self



/**
 * Ajax Helpers
 */

/**
 * 
 * @param {string} url
 * @param {array} parameters
 * @param {function(data, textStatus, jqXHR)} successCallback the `data` parameter is already parsed JSON.
 * @param {function(errMsg, errId, errObj, textStatus, jqXHR)} errorCallback if the server returns an exception, this method will be called. The exception will contain at least the following: {:message => msg, :error_id => id, :error => :ajax_error}
 * @returns {XMLHTTPRequest} see http://api.jquery.com/jQuery.post/#jqxhr-object
 */
function callJSON(url, parameters, successCallback, errorCallback) {
    if (!parameters)
        parameters = {};
    return $.post(url, parameters, function(data, textStatus, jqXHR) {
        if (data && data['error'] == 'ajax_error') {
            if (errorCallback) {
                errorCallback(data['message'], data['error_id'], data, textStatus, jqXHR);
            } else {
                // Display an error:
                console.log("Ajax Call Error :: Url: " + url + " :: Message: " + data['message'] + " :: Error ID: " + data['error_id']);
            }
        } else {
            successCallback(data, textStatus, jqXHR);
        }
    });
}



/**
 * jQuery Initialisation
 */
$(function() {
    /**
     * UI Utilities
     */

    /**
     * Common UI Behaviour
     */
    $('.clickable-link').click(function(e) {
        window.location = $(this).attr('data-cl-href');
        e.preventDefault();
    });

    $('.button-behaviour').disableSelection();
});
