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
  }])
  .controller("ResultsCtrl", ["$scope", "$http",
    function($scope, $http){
      $scope.eventSources = [];
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
    }
  ])
;