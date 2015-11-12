(function () {
  $.get('api/v1/auth/is_logged_in.json', {})
    .done(function (response) {
      if (response.is_logged_in) {
        goToApp();
      }
    });
})();

// preloader
$(window).load(function () {
  $('.preloader').fadeOut(500); // set duration in brackets
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
      .done(goToApp)
      .fail(function (data) {
        logInAlert.show();
      })
      .always(function () {
        enableForm(logInForm);
      });
    event.preventDefault();
  });

  var signInSection = $('#sign-in');
  signInSection.hide();

  $('.navbar-collapse a.sign-in').click(function () {
    signInSection.slideToggle(300, function () {
      logInEmail.focus();
    });
    $('#divider,#feature,#feature1,#feature2,#download,#contact').toggle(0);
    $('#home').slideToggle(300);
  });

  function disableForm(form) {
    form.find('input,button,textarea').attr('disabled', '');
  }

  function enableForm(form) {
    form.find('input,button,textarea').removeAttr('disabled');
  }

  var contactForm = $('.contact-form form');
  var contactEmail = contactForm.find('input.email');
  var contactMessage = contactForm.find('textarea.message');
  var failureAlert = contactForm.find('div.alert-danger');
  var successAlert = contactForm.find('div.alert-success');
  hideContactUsAlerts();
  contactForm.find('input.send').click(function (event) {
    disableForm(contactForm);
    hideContactUsAlerts();
    $.post('api/v1/queries/general_query.json', {email: contactEmail.val(), message: contactMessage.val()})
      .done(function () {
        successAlert.show();
      })
      .fail(function () {
        failureAlert.show();
      })
      .always(function () {
        enableForm(contactForm);
      });
    event.preventDefault();
  });

  function hideContactUsAlerts() {
    failureAlert.hide();
    successAlert.hide();
  }
});

function goToApp() {
  window.location.href = '/app';
}