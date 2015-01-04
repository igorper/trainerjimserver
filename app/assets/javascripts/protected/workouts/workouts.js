//= require apiLinks
//= require angular-ui-sortable/sortable
//= require angular-sanitize/angular-sanitize
//= require angular-ui-select/dist/select
//= require trainings/training
//= require exerciseTypes/exerciseType

angular
  .module('protected.workouts', [
    'ui.router',
    'ui.bootstrap',
    'ui.sortable',
    'ngSanitize',
    'ui.select',
    'trainings',
    'exerciseTypes'
  ])
  .config(['$stateProvider', function ($stateProvider) {
    $stateProvider
      .state('protected.workouts', {
        url: "/workouts",
        controller: "WorkoutsCtrl",
        templateUrl: "protected/workouts/workouts.html"
      });
  }])
  .controller("WorkoutsCtrl", ["$scope", "$window", '$modal', 'Training',
    function ($scope, $window, $modal, Training) {
      var REPETITIONS_STEP = 1;
      var WEIGHT_STEP = 5;
      var REST_STEP = 5;

      $scope.templates = [];
      $scope.selectedTraining = null;
      $scope.selectedSeries = [];

      Training.query(function (trainings) {
        $scope.templates = trainings;
      }, function () {
        $window.alert("Could get the list of trainings. Try logging in again.")
      });

      $scope.showTemplate = function (template) {
        Training.get(template, function (training) {
          $scope.selectedTraining = training;
          $scope.selectedSeries = [];
          // select default series to show for each exercise
          for (var i = 0; i < training.exercises.length; i++) {
            training.exercises[i].selectedSeries = 0;
          }
        }, function () {
          $window.alert("Unable to fetch the training.");
        });
      };

      $scope.createEmptyTraining = function () {
        $scope.selectedTraining = new Training();
        $scope.selectedTraining.name = "Enter training name";
        $scope.selectedTraining.exercises = [];
      };

      $scope.changeSelectedSeries = function (exercise, seriesIdx) {
        exercise.selectedSeries = seriesIdx;
      };

      $scope.sortableOptions = {
        handle: '.move'
      };

      $scope.getSelectedSeries = function (exercise) {
        return exercise.series[exercise.selectedSeries];
      };

      $scope.increaseSeriesRepetitions = function (exercise) {
        $scope.getSelectedSeries(exercise).repeat_count += REPETITIONS_STEP;
      };

      $scope.decreaseSeriesRepetitions = function (exercise) {
        var series = $scope.getSelectedSeries(exercise);
        series.repeat_count = series.repeat_count < REPETITIONS_STEP ? 0 : series.repeat_count - REPETITIONS_STEP;
      };

      $scope.increaseSeriesWeight = function (exercise) {
        $scope.getSelectedSeries(exercise).weight += WEIGHT_STEP;
      };

      $scope.decreaseSeriesWeight = function (exercise) {
        var series = $scope.getSelectedSeries(exercise);
        series.weight = series.weight < WEIGHT_STEP ? 0 : series.weight - WEIGHT_STEP;
      };

      $scope.increaseSeriesRest = function (exercise) {
        $scope.getSelectedSeries(exercise).rest_time += REST_STEP;
      };

      $scope.decreaseSeriesRest = function (exercise) {
        var series = $scope.getSelectedSeries(exercise);
        series.rest_time = series.rest_time < REST_STEP ? 0 : series.rest_time - REST_STEP;
      };

      $scope.editExercise = function (exercise) {
        var modalInstance = $modal.open({
          templateUrl: 'protected/workouts/select_exercise.html',
          controller: 'SelectExerciseCtrl',
          backdrop: 'static',
          windowClass: 'modal-window'
        });

        modalInstance.result.then(function (selectedExercise) {
          $scope.selectedTraining.exercises.unshift(
            {
              duration_after_repetition: null,
              duration_up_repetition: null,
              duration_middle_repetition: null,
              duration_down_repetition: null,
              guidance_type: "manual",
              selectedSeries: 0,
              series: [
                {
                  repeat_count: 0,
                  weight: 0,
                  rest_time: 0
                }
              ],
              exercise_type: selectedExercise
            });
        });
      };

      $scope.onSaveClicked = function (selectedTraining) {
        $scope.selectedTraining.$save(function () {
          console.log("successfully saved!");
        }, function () {
          console.log("not saved!");
        });
      };
    }
  ]).controller("SelectExerciseCtrl", ["$scope", '$modalInstance', 'ExerciseType',
    function ($scope, $modalInstance, ExerciseType) {
      $scope.exercise = {};
      $scope.exercises = [];

      $scope.ok = function () {
        if ($scope.exercise.selected == undefined) {
          console.log("You should select it.");
        } else {
          $modalInstance.close($scope.exercise.selected);
        }
      };

      $scope.cancel = function () {
        $modalInstance.dismiss();
      };

      ExerciseType.query(function (data) {
        $scope.exercises = data;
      }, function (data, status, headers) {
        console.error("Could not fetch exercises.");
      });
    }
  ]).filter('propsFilter', function () {
    return function (items, props) {
      var out = [];

      if (angular.isArray(items)) {
        items.forEach(function (item) {
          var itemMatches = false;

          var keys = Object.keys(props);
          for (var i = 0; i < keys.length; i++) {
            var prop = keys[i];
            var text = props[prop].toLowerCase();
            if (item[prop].toString().toLowerCase().indexOf(text) !== -1) {
              itemMatches = true;
              break;
            }
          }

          if (itemMatches) {
            out.push(item);
          }
        });
      } else {
        // Let the output be the input untouched
        out = items;
      }

      return out;
    }
  });