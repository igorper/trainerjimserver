//= require angular/angular
//= require angular-ui-router/release/angular-ui-router.min.js
//= require welcome/welcome
//= require workouts/templates/templates

angular
  .module('app', [
    'welcome',
    'workouts.templates'
  ])
  .config(['$urlRouterProvider', function ($urlRouterProvider) {
    $urlRouterProvider.otherwise("/welcome");
  }]);