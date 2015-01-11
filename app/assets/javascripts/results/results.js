//= require apiLinks
//= require angular-bootstrap/ui-bootstrap-tpls
//= require shared/shared

angular
  .module('results', [
    'ui.router',
    'ui.bootstrap',
    'shared',
    'ui.calendar'
  ])
  .config(['$stateProvider', '$urlRouterProvider', function ($stateProvider) {
    $stateProvider
      .state('results', {
        url: "/results",
        controller: "ResultsCtrl",
        templateUrl: "results/results.html"
      });
  }]).factory("Result", ["$resource", function ($resource) {
    return $resource("/api/v1/results/:id.json");
  }])
  .controller("ResultsCtrl", ["$scope", "$http", "Result",
    function($scope, $http, Result){

      var date = new Date();
      var d = date.getDate();
      var m = date.getMonth();
      var y = date.getFullYear();

      $scope.eventSources = [];

      $scope.results = null;
      /* config object */
      $scope.uiConfig = {
        calendar:{
          height: 450,
          editable: true,
          header:{
            right: 'today prev,next'
          },
          dayClick: $scope.alertEventOnClick,
          eventDrop: $scope.alertOnDrop,
          eventResize: $scope.alertOnResize
        }
      };

      Result.query(function (data) {
        $scope.results = data;

        $scope.eventSources.push([{start: new Date($scope.results[0].start_time), end: new Date($scope.results[0].end_time), title: "Workout"}])
      }, function (data, status, headers) {
        console.error("Could not fetch exercises.");
      });
    }
  ])
;