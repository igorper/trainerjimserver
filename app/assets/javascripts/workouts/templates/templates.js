//= require apiLinks
//= require angular/angular.min
//= require angular-bootstrap/ui-bootstrap-tpls.min

angular
  .module('workouts.templates', [
    'ui.router',
    'ui.bootstrap'
  ])
  .config(['$stateProvider', '$urlRouterProvider', function ($stateProvider) {
    $stateProvider
      .state('workouts/templates', {
        url: "/workouts/templates",
        controller: "TemplatesCtrl",
        templateUrl: "workouts/templates/templates.html"
      });
  }])
  .controller("TemplatesCtrl", ["$scope", "$http", "$window",
    function($scope, $http, $window){
      $scope.test = "BLA";
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