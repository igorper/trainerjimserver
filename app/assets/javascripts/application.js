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
 * @returns {XMLHTTPRequest} see http://api.jquery.com/jQuery.post/#jqxhr-object
 */
function callJSON(url, parameters, successCallback) {
    if (!parameters)
        parameters = {};
    return $.post(url, parameters, function (data, textStatus, jqXHR) {
            successCallback(jQuery.parseJSON(data), textStatus, jqXHR);
        });
}

$(function () {
    /**
     * UI Utilities
     */
    
    /**
     * Common UI Behaviour
     */
    $('.clickable-link').click(function (e) {
        window.location = $(this).attr('data-cl-href');
        e.preventDefault();
    });
    
    $('.standard-button').disableSelection();
});
