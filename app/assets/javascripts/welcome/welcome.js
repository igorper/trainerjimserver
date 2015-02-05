//= require auth/loginPanel/loginPanel
//= require angular-bootstrap/ui-bootstrap-tpls
//= require auth/auth

angular
  .module('welcome', [
    'ui.router',
    'ui.bootstrap',
    'auth.loginPanel',
    'auth'
  ])
  .config(['$stateProvider', function ($stateProvider) {
    $stateProvider
      .state('welcome', {
        url: "/welcome",
        views: {
          'body': {
            controller: "WelcomeCtrl",
            templateUrl: "welcome/welcome.html"
          },
          'footer': {template: ""},
          'header': {template: ""}
        }
      });
  }])
  .controller("WelcomeCtrl", ["$scope", "$state", 'Auth',
    function ($scope, $state, Auth) {
      $scope.onLoggedIn = function () {
        $state.go('main.workouts');
      };

      Auth.isLoggedIn(function (response) {
        if (response.is_logged_in) {
          $state.go('main.workouts');
        }
      });
    }
  ]);