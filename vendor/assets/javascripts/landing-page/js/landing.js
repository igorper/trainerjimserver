goToAppIfLoggedIn();

$(window).load(function () {
  $('.preloader').fadeOut(500); // set duration in brackets
});

$(function () {
  new WOW().init();
  $('.templatemo-nav').singlePageNav({
    offset: 70
  });

  navbarCollapseOnClick();

  $('.navbar-collapse li a.sign-in').click(function (event) {
    window.location.href = '/login';
    event.preventDefault();
  });

  var contactForm = $('.contact-form form');
  var contactEmailFormGroup = contactForm.find('.form-group.email');
  var contactEmail = contactForm.find('input.email');
  var emailInvalidAlert = contactForm.find('div.email-invalid');
  var contactMessage = contactForm.find('textarea.message');
  var failureAlert = contactForm.find('div.post-failure');
  var successAlert = contactForm.find('div.post-success');

  contactForm.find('input.send').click(function (event) {
    hideContactUsAlerts();
    if (isValidEmail(contactEmail.val())) {
      disableForm(contactForm);
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
    } else {
      console.log("NOT A VALID EMAIL!");
      contactEmailFormGroup.addClass('has-error');
      emailInvalidAlert.show();
    }
    event.preventDefault();
  });

  function hideContactUsAlerts() {
    failureAlert.hide();
    successAlert.hide();
    emailInvalidAlert.hide();
    contactEmailFormGroup.removeClass('has-error');
  }
});