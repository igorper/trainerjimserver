//= require jquery
//= require jquery-ui
//= require_self

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
