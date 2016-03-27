var exerciseTypes = angular.module('exerciseTypes.exerciseType', ['ngResource']);

exerciseTypes.factory('ExerciseType', ['$resource', '$translate', function ($resource, $translate) {
  return $resource(
    '/api/v1/exercise_types/:id.json',
    {},
    {paginationInfo: {method: 'GET', params: {pagination_info: true}}}
  );
}]);