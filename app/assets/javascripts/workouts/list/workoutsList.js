//= require trainings/training

angular.module('workouts.list', [
  'trainings',
  'toaster'
])
  .directive('workoutsList', function () {
    return {
      restrict: 'E',
      scope: {
        workouts: '=workouts',
        selectedWorkout: '=selectedWorkout',
        onWorkoutSelected: '&onWorkoutSelected',
        onWorkoutCreate: '&onWorkoutCreate'
      },
      controller: 'WorkoutsListCtrl',
      templateUrl: 'workouts/list/workouts-list.html'
    };
  })
  .controller('WorkoutsListCtrl', ['$scope', function ($scope) {
  }])
;

