$(function() {
    var frmPagination = $('form#pagination');
    var pageInput = $('input#page');
    var totalPages = parseInt($('input[name="totalPages"]').val());

    function getCurrentPage() {
        return parseInt(pageInput.val());
    }

    $('div#prevpage').click(function() {
        if (getCurrentPage() > 1) {
            pageInput.val(getCurrentPage() - 1);
            frmPagination.submit();
        }
    });

    $('div#nextpage').click(function() {
        if (getCurrentPage() < totalPages) {
            pageInput.val(getCurrentPage() + 1);
            frmPagination.submit();
        }
    });

    $('div.page-nav-button').disableSelection();
});