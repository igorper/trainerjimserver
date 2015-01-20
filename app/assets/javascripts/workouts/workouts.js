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
        url: "/workouts?:id",
        controller: "WorkoutsCtrl",
        templateUrl: "workouts/workouts.html"
      });
  }])
  .controller("WorkoutsCtrl", ["$scope", '$modal', 'Training', '$stateParams', 'toaster',
    function ($scope, $modal, Training, $stateParams, toaster) {
      $scope.templates = [];
      $scope.selectedTraining = null;

      function refreshTrainingsList() {
        Training.query(function (trainings) {
          $scope.templates = trainings;
        }, function () {
          toaster.pop("error", "Fetch trainings error", "Unable to fetch the trainings list");
        });
      }

      function createEmptyTraining() {
        return new Training({name: "Enter training name", exercises: []});
      }

      refreshTrainingsList();

      if ($stateParams.id != undefined) {
        if($stateParams.id === 'new'){
          $scope.selectedTraining = createEmptyTraining();
        } else {
          Training.get({id: $stateParams.id}, function (training) {
            $scope.selectedTraining = training;
          }, function () {
            toaster.pop("error", "Fetch training error", "Unable to fetch the training");
          });
        }
      }

      $scope.onSaveClicked = function (selectedTraining) {
        $scope.selectedTraining.$save(function () {
          refreshTrainingsList();
          toaster.pop("success", "Training saved", "Sucessfully saved " + selectedTraining.name);
          $scope.selectedTraining = null;
        }, function () {
          toaster.pop("error", "Training save error", "Error saving " + selectedTraining.name);
        });
      };

      $scope.onDeleteClicked = function (selectedTraining) {
        toaster.pop("info", "Training delete", "clicked");
      };

    }
  ]);