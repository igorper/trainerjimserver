//= require apiLinks
//= require angular/angular
//= require angular-bootstrap/ui-bootstrap-tpls
//= require shared/shared
//= require angular-ui-grid/ui-grid

angular
  .module('trainees', [
    'ui.router',
    'ui.bootstrap',
    'shared',
    'ui.grid'
  ])
  .factory("Trainee", ["$resource", function ($resource) {
    return $resource("/api/v1/trainees/:id.json");
  }])
  .config(['$stateProvider', function ($stateProvider) {
    $stateProvider
      .state('trainees', {
        url: "/trainees",
        controller: "TraineesCtrl",
        templateUrl: "trainees/trainees.html"
      });
  }])
  .controller("TraineesCtrl", ["$scope", "Trainee",
    function ($scope, Trainee) {
      function refreshTraineesList() {
        Trainee.query(function (trainees) {
          $scope.trainees = trainees;
        }, function () {
          $window.alert("Could get the list of trainees. Try logging in again.")
        });
      }

      refreshTraineesList();
    }
  ])
;