//= require angular/angular.min
//= require angular-ui-router/release/angular-ui-router.min.js
//= require welcome/welcome

angular
  .module('app', [
    'welcome'
  ])
  .config(['$urlRouterProvider', function ($urlRouterProvider) {
    $urlRouterProvider.otherwise("/welcome");
  }]);