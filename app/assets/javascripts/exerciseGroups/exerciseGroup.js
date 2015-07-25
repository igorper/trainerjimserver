var exerciseGroups = angular.module('exerciseGroups.exerciseGroup', ['ngResource']);

exerciseGroups.factory('ExerciseGroup', ['$resource', function ($resource) {
  return $resource('/api/v1/exercise_groups/:id.json');
}]);