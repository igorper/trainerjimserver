//= require jquery
//= require jquery.ui.all
//= require bootstrap
//= require_self



////////////////////////////////////////////////////////////////////////////////
/// Ajax Helpers
//

/**
 * This function is called whenever there's an error when calling an AJAX
 * function.
 * 
 * By default the error is passed to the console log.
 * 
 * To override this just assign your own function, e.g.:
 * 
 *  `on_json_error_behaviour = alertOnJsonError;`
 * 
 * @type {function(errMsg, errId, errObj, textStatus, jqXHR, requestUrl)}
 */
var on_json_error_behaviour = null;

function logOnJsonError(errMsg, errId, data, textStatus, jqXHR, requestUrl) {
    console.log("Ajax Call Error :: Url: " + requestUrl + " :: Message: " + errMsg + " :: Error ID: " + errId);
}

function alertOnJsonError(errMsg, errId, data, textStatus, jqXHR, requestUrl) {
    logOnJsonError(errMsg, errId, data, textStatus, jqXHR, requestUrl);
    if (errMsg)
        alert('An error occurred while processing a request.\n\n' + errMsg);
    else
        alert('An error occurred while processing a request. Internal error id:\n\n' + errId);
}

function onJSONError(errMsg, errId, data, textStatus, jqXHR, requestUrl) {
    if (on_json_error_behaviour) {
        on_json_error_behaviour(errMsg, errId, data, textStatus, jqXHR, requestUrl)
    } else {
        // Just the error:
        logOnJsonError(errMsg, errId, data, textStatus, jqXHR, requestUrl);
    }
}

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
                onJSONError(data['message'], data['error_id'], data, textStatus, jqXHR, url);
            }
        } else {
            successCallback(data, textStatus, jqXHR);
        }
    }).fail(function(jqXHR, textStatus) {
        var errMsg = "Unknown exception";
        var errId = "unknown_exception";
        var data = null;
        if (jqXHR.responseText) {
            data = $.parseJSON(jqXHR.responseText);
            errMsg = data['message'];
            errId = data['error_id'];
        }
        if (errorCallback) {
            errorCallback(errMsg, errId, data, textStatus, jqXHR, url);
        } else {
            onJSONError(errMsg, errId, data, textStatus, jqXHR, url);
        }
    });
}



////////////////////////////////////////////////////////////////////////////////
/// Sammy Helpers
//
function joinPaths(pathElement1, pathElement2, etc) {
    return Array.prototype.join.call(arguments, '/');
}
function getSammyLink(pathElement1, pathElement2, etc) {
    return '#' + Array.prototype.join.call(arguments, '/');
}



////////////////////////////////////////////////////////////////////////////////
/// jQuery Initialisation
//
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

    /**
     * Buttons
     */
    $('.button-behaviour').disableSelection();

    $('.button-behaviour').mousedown(function() {
        $(this).addClass("pressed");
    });

    $('.button-behaviour').mouseup(function() {
        $(this).removeClass("pressed");
    });
});



////////////////////////////////////////////////////////////////////////////////
/// Ajax Initialisation
//
///Makes all ajax request automaticly send over CSRF token too.
$.ajaxSetup({
    beforeSend: function(xhr) {
        xhr.setRequestHeader('X-CSRF-Token',
                $('meta[name="csrf-token"]').attr('content'));
    }
});



////////////////////////////////////////////////////////////////////////////////
/// Text Input Autogrow
//
(function($) {

    // jQuery autoGrowInput plugin by James Padolsey
    // See related thread: http://stackoverflow.com/questions/931207/is-there-a-jquery-autogrow-plugin-for-text-fields

    $.fn.autoGrowInput = function(o) {

        o = $.extend({
            maxWidth: 1000,
            minWidth: 0,
            comfortZone: 70
        }, o);

        this.filter('input:text').each(function() {

            var minWidth = o.minWidth || $(this).width(),
                    val = '',
                    input = $(this),
                    testSubject = $('<tester/>').css({
                position: 'absolute',
                top: -9999,
                left: -9999,
                width: 'auto',
                fontSize: input.css('fontSize'),
                fontFamily: input.css('fontFamily'),
                fontWeight: input.css('fontWeight'),
                letterSpacing: input.css('letterSpacing'),
                whiteSpace: 'nowrap'
            }),
            check = function() {

                if (val === (val = input.val())) {
                    return;
                }

                // Enter new content into testSubject
                var escaped = val.replace(/&/g, '&amp;').replace(/\s/g, '&nbsp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
                testSubject.html(escaped);

                // Calculate new width + whether to change
                var testerWidth = testSubject.width(),
                        newWidth = (testerWidth + o.comfortZone) >= minWidth ? testerWidth + o.comfortZone : minWidth,
                        currentWidth = input.width(),
                        isValidWidthChange = (newWidth < currentWidth && newWidth >= minWidth)
                        || (newWidth > minWidth && newWidth < o.maxWidth);

                // Animate width
                if (isValidWidthChange) {
                    input.width(newWidth);
                }

            };

            testSubject.insertAfter(input);

            $(this).bind('keyup keydown blur update input', check);

        });

        return this;

    };

})(jQuery);