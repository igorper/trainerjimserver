//= require auth/auth

var startModule = angular.module('start', [
  'ui.router',
  'auth'
]);

startModule.config(['$stateProvider', function ($stateProvider) {
  $stateProvider.state('start', {
    url: "/start",
    views: {
      'body': {
        controller: ['$scope', '$state', 'Auth', function ($scope, $state, Auth) {
          Auth.isLoggedIn(function (response) {
            $state.go(response.is_logged_in ? 'main.workouts.workout' : 'welcome');
          });
        }],
        template: ''
      },
      'footer': {template: ""},
      'header': {template: ""}
    }
  });
}]);