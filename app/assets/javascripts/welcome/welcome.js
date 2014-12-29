//= require apiLinks
//= require users/loginPanel.js
//= require angular/angular.min
//= require angular-bootstrap/ui-bootstrap-tpls.min

angular
  .module('welcome', [
    'ui.router',
    'ui.bootstrap',
    'users'
  ])
  .config(['$stateProvider', '$urlRouterProvider', function ($stateProvider) {
    $stateProvider
      .state('welcome', {
        url: "/welcome",
        templateUrl: "welcome/welcome.html"
      });
  }]);