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

function isValidEmail(email) {
  var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
  return regex.test(email);
}