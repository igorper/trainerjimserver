//= require apiLinks
//= require angular/angular.min
//= require angular-bootstrap/ui-bootstrap-tpls.min

angular
  .module('protected.trainees', [
    'ui.router',
    'ui.bootstrap'
  ])
  .config(['$stateProvider', '$urlRouterProvider', function ($stateProvider) {
    $stateProvider
      .state('protected.trainees', {
        url: "/users",
        controller: "TraineesCtrl",
        templateUrl: "protected/trainees/trainees.html"
      });
  }])
  .controller("TraineesCtrl", ["$scope", "$http", "$window",
    function($scope, $http, $window){
      $scope.test = "Users";
    }
  ])
;