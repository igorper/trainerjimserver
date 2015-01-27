//= require underscore/underscore
//= require jquery/dist/jquery
//= require jquery-ui/ui/jquery-ui
//= require angular/angular
//= require angular-ui-router/release/angular-ui-router
//= require angular-ui-calendar/src/calendar
//= require fullcalendar/fullcalendar
//= require fullcalendar/gcal
//= require welcome/welcome
//= require workouts/workouts
//= require trainees/trainees
//= require results/results

angular
  .module('app', [
    'welcome',
    'workouts',
    'trainees',
    'results'
  ])
  .config(['$stateProvider', function ($stateProvider) {
    $stateProvider
      .state('main', {
        abstract: true,
        url: "",
        views: {
          'body': {templateUrl: "main.html"},
          'footer': {templateUrl: 'shared/footer-view.html'},
          'header': {templateUrl: 'shared/header-view.html'}
        }
      })
    ;
  }])
  .config(['$urlRouterProvider', function ($urlRouterProvider) {
    $urlRouterProvider.otherwise("/welcome");
  }]);