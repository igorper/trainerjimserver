//= require angular-ui-sortable/sortable
//= require angular-sanitize/angular-sanitize
//= require angular-ui-select/dist/select
//= require trainings/training
//= require exerciseTypes/exerciseType
//= require shared/shared
//= require angular-animate/angular-animate
//= require angularjs-toaster/toaster

angular
  .module('workouts', [
    'ui.router',
    'ui.bootstrap',
    'ui.sortable',
    'ngSanitize',
    'ui.select',
    'trainings',
    'exerciseTypes',
    'shared',
    'ngAnimate',
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
      var REPETITIONS_STEP = 1;
      var WEIGHT_STEP = 5;
      var REST_STEP = 5;

      $scope.templates = [];
      $scope.selectedTraining = null;
      $scope.selectedSeries = [];

      function refreshTrainingsList() {
        Training.query(function (trainings) {
          $scope.templates = trainings;
        }, function () {
          toaster.pop("error", "Fetch trainings error", "Unable to fetch the trainings list");
        });
      }

      function createEmptyTraining() {
        $scope.selectedTraining = new Training();
        $scope.selectedTraining.name = "Enter training name";
        $scope.selectedTraining.exercises = [];
      }

      refreshTrainingsList();

      if ($stateParams.id != undefined) {
        if($stateParams.id === 'new'){
          createEmptyTraining();
        } else {
          Training.get({id: $stateParams.id}, function (training) {
            $scope.selectedTraining = training;
            resetSelectedSeries();
          }, function () {
            toaster.pop("error", "Fetch training error", "Unable to fetch the training");
          });
        }
      }

      $scope.changeSelectedSeries = function (exercise, seriesIdx) {
        exercise.selectedSeries = seriesIdx;
      };

      $scope.sortableOptions = {
        handle: '.move'
      };

      $scope.getSelectedSeries = function (exercise) {
        return exercise.series[exercise.selectedSeries];
      };

      $scope.addSeries = function (exercise) {
        exercise.series.push(angular.copy($scope.getSelectedSeries(exercise)));
      };

      $scope.removeSeries = function (exercise) {
        // there has to be at least one exercise
        if (exercise.series.length > 1) {
          exercise.series.splice(exercise.series.indexOf($scope.getSelectedSeries(exercise)), 1);
        }
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
          templateUrl: 'workouts/select_exercise.html',
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
        $scope.selectedTraining.$save(function (data) {
          resetSelectedSeries();
          refreshTrainingsList();
          toaster.pop("success", "Training saved", "Sucessfully saved " + selectedTraining.name);
          $scope.selectedTraining = null;
        }, function () {
          toaster.pop("error", "Training save error", "Error saving " + selectedTraining.name);
        });
      };

      function resetSelectedSeries() {
        $scope.selectedSeries = [];
        // select default series to show for each exercise
        for (var i = 0; i < $scope.selectedTraining.exercises.length; i++) {
          $scope.selectedTraining.exercises[i].selectedSeries = 0;
        }
      }
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