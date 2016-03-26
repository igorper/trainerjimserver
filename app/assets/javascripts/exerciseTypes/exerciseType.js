var exerciseTypes = angular.module('exerciseTypes.exerciseType', ['ngResource', 'pascalprecht.translate']);

exerciseTypes.factory('ExerciseType', ['$resource', '$translate', function ($resource, $translate) {
  var ExerciseType = $resource(
    '/api/v1/exercise_types/:id.json',
    {},
    {paginationInfo: {method: 'GET', params: {pagination_info: true}}}
  );

  var oldQuery = ExerciseType.query;
  ExerciseType.query = function () {
    return oldQuery({language: $translate.proposedLanguage()});
  };

  return ExerciseType;
}]);