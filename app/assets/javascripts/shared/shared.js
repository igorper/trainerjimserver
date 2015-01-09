//= require apiLinks
//= require pageLinks

angular.module('shared', [])
  .directive('header', function () {
    return {
      restrict: 'E',
      controller: 'HeaderCtrl',
      templateUrl: 'shared/header.html'
    }
  })
  .controller('HeaderCtrl', ['$scope', '$http', '$window', function ($scope, $http, $window) {
    $scope.topNavigation = [
      {
        name: "Workouts",
        link: "workouts"
      },
      {
        name: "Trainees",
        link: "trainees"
      },
      {
        name: "Results",
        link: "results"
      }
    ]
  }])
  .directive('footer', function () {
    return {
      restrict: 'E',
      controller: 'FooterCtrl',
      templateUrl: 'shared/footer.html'
    }
  })
  .controller('FooterCtrl', ['$scope', '$http', '$window', function ($scope, $http, $window) {

  }]);

