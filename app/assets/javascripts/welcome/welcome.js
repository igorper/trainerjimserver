//= require users/loginPanel.js
//= require angular-bootstrap/ui-bootstrap-tpls
//= require auth/auth

angular
  .module('welcome', [
    'ui.router',
    'ui.bootstrap',
    'users',
    'auth'
  ])
  .config(['$stateProvider', function ($stateProvider) {
    $stateProvider
      .state('welcome', {
        url: "/welcome",
        controller: "WelcomeCtrl",
        templateUrl: "welcome/welcome.html"
      });
  }])
  .controller("WelcomeCtrl", ["$scope", "$state", 'Auth',
    function ($scope, $state, Auth) {
      $scope.onLoggedIn = function () {
        $state.go('workouts');
      };

      Auth.isLoggedIn(function (response) {
        if (response.is_logged_in) {
          $state.go('workouts');
        }
      });
    }
  ]);