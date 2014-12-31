//= require apiLinks
//= require angular/angular
//= require angular-bootstrap/ui-bootstrap-tpls
//= require protected/trainees/trainees
//= require protected/workouts/workouts

angular
  .module('protected', [
    'ui.router',
    'ui.bootstrap',
    'protected.trainees',
    'protected.workouts'
  ])
  .config(['$stateProvider', '$urlRouterProvider', function ($stateProvider) {
    $stateProvider
      .state('protected', {
        abstract: true,
        controller: "FrameCtrl",
        templateUrl: "protected/frame.html"
      });
  }])
  .controller("FrameCtrl", ["$scope", "$http", "$window",
    function($scope, $http, $window){
      $scope.topNavigation = [
        {
          name: "Workouts",
          link: "protected.workouts"
        },
        {
          name: "Trainees",
          link: "protected.trainees"
        }
      ]
    }
  ])
;