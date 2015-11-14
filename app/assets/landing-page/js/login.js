$(function () {
  navbarCollapseOnClick();

  var signUpForm = $('.sign-up-form');
  var logInForm = $('.log-in-form');

  var signUpAlert = signUpForm.find('.alert-danger');
  var signUpSuccessAlert = signUpForm.find('.alert-success');
  var signUpEmail = signUpForm.find('#email');
  var signUpPassword = signUpForm.find('#password');
  var signUpFullName = signUpForm.find('#full_name');
  var signUpRegistrationToken = signUpForm.find('#registration_token');
  signUpAlert.hide();
  signUpSuccessAlert.hide();

  signUpForm.find('.btn.submit').click(function (event) {
    disableForm(signUpForm);
    signUpAlert.hide();
    signUpSuccessAlert.hide();
    $.post('api/v1/auth/signup.json', {
      email: signUpEmail.val(),
      password: signUpPassword.val(),
      full_name: signUpFullName.val(),
      registration_token: signUpRegistrationToken.val()
    })
      .done(function (data) {
        signUpSuccessAlert.show();
      })
      .fail(function (data) {
        signUpAlert.show();
      })
      .always(function () {
        enableForm(signUpForm);
      });
    event.preventDefault();
  });

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

  $('.panel-footer a').click(function (event) {
    logInForm.toggle();
    signUpForm.toggle();
    event.preventDefault();
  });
});