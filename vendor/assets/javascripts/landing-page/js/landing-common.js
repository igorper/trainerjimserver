function goToAppIfLoggedIn() {
  $.get('api/v1/auth/is_logged_in.json', {})
    .done(function (response) {
      if (response.is_logged_in) {
        goToApp();
      }
    });
}

function disableForm(form) {
  form.find('input,button,textarea').attr('disabled', '');
}

function enableForm(form) {
  form.find('input,button,textarea').removeAttr('disabled');
}

function goToApp() {
  window.location.href = '/app';
}

function navbarCollapseOnClick() {
  $('.navbar-collapse a').click(function () {
    $(".navbar-collapse").collapse('hide');
  });
}