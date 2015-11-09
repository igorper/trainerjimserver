// preloader
$(window).load(function () {
  $('.preloader').fadeOut(1000); // set duration in brackets
});

$(function () {
  new WOW().init();
  $('.templatemo-nav').singlePageNav({
    offset: 70
  });

  /* Hide mobile menu after clicking on a link
   -----------------------------------------------*/
  $('.navbar-collapse a').click(function () {
    $(".navbar-collapse").collapse('hide');
  });

  var signUpForm = $('.sign-up-form');
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

  var logInForm = $('.log-in-form');
  var logInEmail = logInForm.find('#email');
  var logInPassword = logInForm.find('#password');
  var logInAlert = logInForm.find('.alert');
  logInAlert.hide();
  logInForm.find('.btn.submit').click(function (event) {
    disableForm(logInForm);
    logInAlert.hide();
    $.post('api/v1/auth/login.json', {email: logInEmail.val(), password: logInPassword.val()})
      .done(function (data) {
        window.location.href = '/';
      })
      .fail(function (data) {
        logInAlert.show();
      })
      .always(function () {
        enableForm(logInForm);
      });
    event.preventDefault();
  });

  function disableForm(form) {
    form.find('input, button').attr('disabled', '');
  }

  function enableForm(form) {
    form.find('input, button').removeAttr('disabled');
  }
});
