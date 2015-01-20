//= require angular/angular
//= require angular-ui-sortable/sortable
//= require angular-sanitize/angular-sanitize
//= require angular-ui-select/dist/select
//= require angular-animate/angular-animate
//= require angularjs-toaster/toaster

angular.module('workouts.editor', [
  'ui.sortable'
])
  .directive('workoutEditor', function () {
    return {
      restrict: 'E',
      scope: {
        training: '=training',
        onSaveClicked: '&onSaveClicked',
        onDeleteClicked: '&onDeleteClicked'
      },
      controller: 'WorkoutEditorCtrl',
      templateUrl: 'workouts/editor/workout-editor.html'
    };
  })
  .controller('WorkoutEditorCtrl', ['$scope', '$modal', function ($scope, $modal) {
    var REPETITIONS_STEP = 1;
    var WEIGHT_STEP = 5;
    var REST_STEP = 5;
    $scope.selectedSeries = [];

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
        $scope.training.exercises.unshift(
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

    function resetSelectedSeries() {
      $scope.selectedSeries = [];
      // select default series to show for each exercise
      for (var i = 0; i < $scope.training.exercises.length; i++) {
        $scope.training.exercises[i].selectedSeries = 0;
      }
    }
  }])
;

