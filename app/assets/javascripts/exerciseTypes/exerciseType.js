var exerciseTypes = angular.module('exerciseTypes.exerciseType', ['ngResource']);

exerciseTypes.factory('ExerciseType', ['$resource', function ($resource) {
  return $resource(
    '/api/v1/exercise_types/:id.json',
    {},
    {paginationInfo: {method: 'GET', params: {pagination_info: true}}}
  );
}]);