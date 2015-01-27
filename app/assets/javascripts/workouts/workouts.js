//= require angular/angular
//= require trainings/training
//= require shared/shared
//= require angularjs-toaster/toaster
//= require workouts/editor/workoutEditor.js
//= require workouts/list/workoutsList.js

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
        $scope.selectedTraining.$save(function () {
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