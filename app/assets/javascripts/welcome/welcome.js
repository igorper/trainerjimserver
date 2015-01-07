//= require apiLinks
//= require users/loginPanel.js
//= require angular/angular
//= require angular-bootstrap/ui-bootstrap-tpls

angular
  .module('welcome', [
    'ui.router',
    'ui.bootstrap',
    'users'
  ])
  .config(['$stateProvider', function ($stateProvider) {
    $stateProvider
      .state('welcome', {
        url: "/welcome",
        controller: "WelcomeCtrl",
        templateUrl: "welcome/welcome.html"
      });
  }])
  .controller("WelcomeCtrl", ["$scope", "$state",
    function ($scope, $state) {
      $scope.onLoggedIn = function () {
        $state.go('workouts');
      };
    }
  ]);