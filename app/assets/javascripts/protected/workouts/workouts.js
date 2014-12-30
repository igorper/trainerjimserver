//= require apiLinks
//= require angular/angular.min
//= require angular-bootstrap/ui-bootstrap-tpls.min

angular
  .module('protected.workouts', [
    'ui.router',
    'ui.bootstrap'
  ])
  .config(['$stateProvider', '$urlRouterProvider', function ($stateProvider) {
    $stateProvider
      .state('protected.workouts', {
        url: "/workouts",
        controller: "WorkoutsCtrl",
        templateUrl: "protected/workouts/workouts.html"
      });
  }])
  .controller("WorkoutsCtrl", ["$scope", "$http", "$window",
    function($scope, $http, $window){
      $scope.test = "WORKOUTS";

      $scope.templates = [];

      $http.get(api_trainings_url)
        .success(function (data, status, headers) {
          $scope.templates = data;
        })
        .error(function (data, status, headers) {
          $window.alert("Could not log in. Check your email and password.")
        });
    }
  ])
;