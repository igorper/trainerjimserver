//= require auth/auth

angular
  .module('start', [
    'ui.router',
    'auth',
    'angularSpinner'
  ])
  .config(['$stateProvider', function ($stateProvider) {
    $stateProvider
      .state('start', {
        url: "/start",
        views: {
          'body': {
            controller: ['$scope', '$state', 'Auth', function ($scope, $state, Auth) {
              Auth.isLoggedIn(function (response) {
                $state.go(response.is_logged_in ? 'main.workouts.workout' : 'welcome');
              });
            }],
            template: '<div us-spinner spinner-key="start-spinner" spinner-start-active="true"></div>'
          },
          'footer': {template: ""},
          'header': {template: ""}
        }
      });
  }]);