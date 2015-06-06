angular.module("exerciseTypes.exerciseType", ["ngResource", 'ngFileUpload'])
  .factory("ExerciseType", ["$resource", 'Upload', function ($resource, Upload) {
    return $resource(
      "/api/v1/exercise_types/:id.json",
      {},
      {paginationInfo: {method: 'GET', params: {pagination_info: true}}}
    );
  }]);