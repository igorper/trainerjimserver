$(function () {
  navbarCollapseOnClick();

  var logInForm = $('.log-in-form');
  var logInEmail = logInForm.find('#email');
  var logInPassword = logInForm.find('#password');
  var logInAlert = logInForm.find('.alert');
  logInAlert.hide();

  logInForm.find('.btn.submit').click(function (event) {
    disableForm(logInForm);
    logInAlert.hide();
    $.post('api/v1/auth/login.json', {email: logInEmail.val(), password: logInPassword.val()})
      .done(goToApp)
      .fail(function (data) {
        logInAlert.show();
      })
      .always(function () {
        enableForm(logInForm);
      });
    event.preventDefault();
  });
});