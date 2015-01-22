//= require angular-bootstrap/ui-bootstrap-tpls
//= require shared/shared
//= require angular-ui-grid/ui-grid
//= require trainings/training

angular.module('trainees', [
  'ui.router',
  'ui.bootstrap',
  'shared',
  'ui.grid',
  'ui.grid.cellNav',
  'trainings'
])
  .factory("Trainee", ["$resource", function ($resource) {
    return $resource("/api/v1/trainees/:id.json");
  }])
  .factory("TraineeTraining", ["$resource", function ($resource) {
    return $resource("/api/v1/trainees/:traineeId/trainings/:trainingId.json");
  }])
  .config(['$stateProvider', function ($stateProvider) {
    $stateProvider
      .state('main.trainees', {
        url: '/trainees',
        controller: "TraineesCtrl",
        templateUrl: "trainees/trainees.html"
      })
      .state('main.trainee', {
        url: '/trainees/{traineeId:int}',
        controller: "TraineeCtrl",
        templateUrl: "trainees/trainee.html"
      });
  }])
  .controller("TraineesCtrl", ['$scope', '$state', 'Trainee', 'toaster', 'uiGridConstants',
    function ($scope, $state, Trainee, toaster, uiGridConstants) {

      $scope.traineesGridConfig = {
        enableFiltering: true,
        columnDefs: [
          {name: 'full_name', enableSorting: true, filter: {condition: uiGridConstants.filter.CONTAINS}},
          {name: 'email', enableSorting: true, filter: {condition: uiGridConstants.filter.CONTAINS}},
          {name: 'id', visible: false}
        ],
        onRegisterApi: function (gridApi) {
          $scope.traineesGridApi = gridApi;
          gridApi.cellNav.on.navigate($scope, function (newRowCol, oldRowCol) {
            $state.go('main.trainee', {traineeId: newRowCol.row.entity.id});
          });
        }
      };

      function refreshTraineesList() {
        Trainee.query(function (trainees) {
          $scope.traineesGridConfig.data = trainees;
        }, function () {
          toaster.pop("error", "Trainees listing", "Could get the list of trainees. Try logging in again.");
        });
      }

      refreshTraineesList();
    }
  ])
  .controller("TraineeCtrl", ["$scope", "$state", 'Trainee', '$stateParams', 'toaster', 'Training', 'uiGridConstants', 'TraineeTraining',
    function ($scope, $state, Trainee, $stateParams, toaster, Training, uiGridConstants, TraineeTraining) {
      $scope.templates = [];

      $scope.traineeTrainingsGridConfig = {
        enableFiltering: true,
        columnDefs: [
          {
            name: 'name',
            displayName: 'Training name',
            enableSorting: true,
            filter: {condition: uiGridConstants.filter.CONTAINS}
          }
        ],
        onRegisterApi: function (gridApi) {
          $scope.traineeTrainingsGridApi = gridApi;
        }
      };

      Trainee.get({id: $stateParams.traineeId}, function (trainee) {
        $scope.trainee = trainee;
      }, function () {
        toaster.pop("error", "Trainee", "Could show the trainee. Try logging in again.");
      });

      function refreshTrainingsList() {
        TraineeTraining.query({traineeId: $stateParams.traineeId}, function (trainings) {
          $scope.traineeTrainingsGridConfig.data = trainings;
        }, function () {
          toaster.pop("error", "Fetch trainings error", "Unable to fetch the trainings list");
        });
      }

      refreshTrainingsList();
    }
  ])
;