//= require trainings/training
//= require shared/shared
//= require workouts/editor/workoutEditor
//= require workouts/list/workoutsList

angular
  .module('workouts', [
    'workouts.editor',
    'workouts.list',
    'ui.router',
    'ui.bootstrap',
    'trainings',
    'shared',
    'toaster'
  ])
  .config(['$stateProvider', function ($stateProvider) {
    $stateProvider
      .state('main.workouts', {
        url: "/workouts/:id",
        controller: "WorkoutsCtrl",
        templateUrl: "workouts/workouts.html"
      })
    ;
  }])
  .controller("WorkoutsCtrl", ["$scope", '$modal', 'Training', '$stateParams', 'toaster', '$state',
    function ($scope, $modal, Training, $stateParams, toaster, $state) {
      $scope.selectedTraining = null;
      $scope.templates = [];

      function refreshTrainingsList() {
        Training.query(function (trainings) {
          $scope.templates = trainings;
        }, function () {
          toaster.pop("error", "Fetch trainings error", "Unable to fetch the trainings list");
        });
      }

      refreshTrainingsList();

      function createEmptyTraining() {
        return new Training({name: "Enter training name", exercises: []});
      }

      if ($stateParams.id === '') {
        $scope.selectedTraining = createEmptyTraining();
      } else {
        Training.get({id: $stateParams.id}, function (training) {
          $scope.selectedTraining = training;
        }, function () {
          toaster.pop("error", "Fetch training error", "Unable to fetch the training");
        });
      }

      $scope.onWorkoutSelected = function (workout) {
        $state.go('main.workouts', {id: workout.id});
      };

      $scope.onWorkoutCreate = function () {
        $state.go('main.workouts', {id: ''});
      };

      $scope.onSaveClicked = function (selectedTraining) {
        $scope.selectedTraining.$save(function (training) {
          toaster.pop("success", "Training saved", "Sucessfully saved " + selectedTraining.name);
          $state.go('main.workouts', {id: training.id}, { reload: true });
        }, function () {
          toaster.pop("error", "Training save error", "Error saving " + selectedTraining.name);
        });
      };

      $scope.onDeleteClicked = function (selectedTraining) {
        Training.delete({id: selectedTraining.id}, function () {
          toaster.pop("info", "Workout deleted", "The workout was successfully deleted.");
          $state.go('main.workouts', {id: ''}, { reload: true });
        }, function () {
          toaster.pop("error", "Workout not deleted", "Could not delete the workout. Please try logging in again.");
        });
      };

    }
  ])
;