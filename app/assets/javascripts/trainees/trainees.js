//= require apiLinks
//= require angular/angular
//= require angular-bootstrap/ui-bootstrap-tpls
//= require shared/shared

angular
  .module('trainees', [
    'ui.router',
    'ui.bootstrap',
    'shared'
  ])
  .config(['$stateProvider', '$urlRouterProvider', function ($stateProvider) {
    $stateProvider
      .state('trainees', {
        url: "/users",
        controller: "TraineesCtrl",
        templateUrl: "trainees/trainees.html"
      });
  }])
  .controller("TraineesCtrl", ["$scope", "$http", "$window",
    function($scope, $http, $window){
      $scope.test = "Users";
    }
  ])
;