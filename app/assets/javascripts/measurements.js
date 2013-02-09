$(function () {
    var pageInput = $('input#page');
    
    $('input#prevpage').click(function (e) {
        pageInput.val(pageInput.val() - 1);
    });
    
    $('input#nextpage').click(function (e) {
        pageInput.val(parseInt(pageInput.val()) + 1);
    });
});