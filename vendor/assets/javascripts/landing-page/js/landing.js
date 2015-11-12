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