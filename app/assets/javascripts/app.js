//= require jquery
//= require jquery-ui
//= require angular/angular
//= require angular-ui-router/release/angular-ui-router
//= require welcome/welcome
//= require protected/frame

angular
  .module('app', [
    'welcome',
    'protected'
  ])
  .config(['$urlRouterProvider', function ($urlRouterProvider) {
    $urlRouterProvider.otherwise("/welcome");
  }]);