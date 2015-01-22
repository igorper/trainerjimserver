//= require angular/angular
//= require trainings/training
//= require shared/shared
//= require angularjs-toaster/toaster
//= require workouts/editor/workoutEditor.js

angular
  .module('workouts', [
    'workouts.editor',
    'ui.router',
    'ui.bootstrap',
    'trainings',
    'shared',
    'toaster'
  ])
  .config(['$stateProvider', function ($stateProvider) {
    $stateProvider
      .state('workouts', {
        abstract: true,
        url: "/workouts",
        views: {
          'body': {templateUrl: "workouts/workouts.html"},
          'footer': {templateUrl: 'shared/footer-view.html'},
          'header': {templateUrl: 'shared/header-view.html'}
        }
      })
      .state('workouts.edit', {
        url: "/:id",
        controller: "WorkoutEditCtrl",
        templateUrl: "workouts/workout-edit.html"
      })
    ;
  }])
  .controller("WorkoutEditCtrl", ["$scope", '$modal', 'Training', '$stateParams', 'toaster', '$state',
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

      $scope.onSaveClicked = function (selectedTraining) {
        $scope.selectedTraining.$save(function () {
          toaster.pop("success", "Training saved", "Sucessfully saved " + selectedTraining.name);
          $state.go('workouts.edit', {id: ''});
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