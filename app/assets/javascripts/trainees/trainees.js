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
      })
      .state('main.trainee.training', {
        url: '/training/:trainingId',
        controller: "TraineeTrainingCtrl",
        templateUrl: "trainees/trainee-training.html",
        resolve: {
          traineeId: ['$stateParams', function ($stateParams) {
            return $stateParams.traineeId;
          }]
        }
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
            $state.go('main.trainee.training', {traineeId: newRowCol.row.entity.id, trainingId: ''});
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
      $scope.traineeWorkouts = [];
      $scope.selectedTraining = [];

      Trainee.get({id: $stateParams.traineeId}, function (trainee) {
        $scope.trainee = trainee;
      }, function () {
        toaster.pop("error", "Trainee", "Could show the trainee. Try logging in again.");
      });

      function refreshWorkoutsList() {
        TraineeTraining.query({traineeId: $stateParams.traineeId}, function (trainings) {
          $scope.traineeWorkouts = trainings;
        }, function () {
          toaster.pop("error", "Fetch workouts error", "Unable to fetch the list of workouts.");
        });
      }

      $scope.onWorkoutSelected = function (workout) {
        $scope.selectedTraining = workout;
        $state.go('main.trainee.training', {trainingId: workout.id});
      };

      $scope.onWorkoutCreate = function () {
        $scope.selectedTraining = null;
        $state.go('main.trainee.training', {trainingId: ''});
      };

      refreshWorkoutsList();
    }
  ])
  .controller("TraineeTrainingCtrl", ["$scope", "$state", '$stateParams', 'toaster', 'TraineeTraining', 'traineeId',
    function ($scope, $state, $stateParams, toaster, TraineeTraining, traineeId) {
      $scope.selectedTraining = [];

      function createEmptyTraining() {
        return new TraineeTraining({traineeId: traineeId, name: "Enter training name", exercises: []});
      }

      if ($stateParams.trainingId === '') {
        $scope.selectedTraining = createEmptyTraining();
      } else {
        TraineeTraining.get({traineeId: traineeId, trainingId: $stateParams.trainingId}, function (training) {
          $scope.selectedTraining = training;
        }, function () {
          toaster.pop("error", "Fetch workout error", "Unable to fetch the workout.");
        });
      }

      $scope.onSaveClicked = function (selectedTraining) {
        $scope.selectedTraining.$save({traineeId: traineeId}, function () {
          toaster.pop("success", "Training saved", "Sucessfully saved " + selectedTraining.name);
          $state.reload();
        }, function () {
          toaster.pop("error", "Training save error", "Error saving " + selectedTraining.name);
        });
      };

      $scope.onDeleteClicked = function (selectedTraining) {
        toaster.pop("info", "Training delete", "clicked");
      };
    }
  ])
;