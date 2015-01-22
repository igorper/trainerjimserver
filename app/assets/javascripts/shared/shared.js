//= require auth/auth

angular.module('shared', ['auth', 'ui.router'])
  .directive('header', function () {
    return {
      restrict: 'E',
      controller: 'HeaderCtrl',
      templateUrl: 'shared/header.html'
    }
  })
  .controller('HeaderCtrl', ['$scope', '$state', 'Auth', function ($scope, $state, Auth) {
    $scope.topNavigation = [
      {
        name: "Workouts",
        link: "main.workouts"
      },
      {
        name: "Trainees",
        link: "main.trainees"
      },
      {
        name: "Results",
        link: "main.results"
      }
    ];

    Auth.username(function (response) {
      $scope.username = response.username;
    });

    $scope.logout = function () {
      Auth.logout(function () {
        $state.go('welcome');
      });
    };
  }])
  .directive('footer', function () {
    return {
      restrict: 'E',
      controller: 'FooterCtrl',
      templateUrl: 'shared/footer.html'
    }
  })
  .controller('FooterCtrl', ['$scope', function ($scope) {

  }]);

