//= require jquery/dist/jquery
//= require jquery-ui/jquery-ui
//= require angular/angular
//= require angular-ui-router/release/angular-ui-router
//= require welcome/welcome
//= require workouts/workouts
//= require trainees/trainees

angular
  .module('app', [
    'welcome',
    'workouts',
    'trainees'
  ])
  .config(['$urlRouterProvider', function ($urlRouterProvider) {
    $urlRouterProvider.otherwise("/welcome");
  }]);