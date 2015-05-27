angular
  .module("exerciseTypes.exerciseType", ["ngResource"])
  .factory("ExerciseType", ["$resource", '$upload', function ($resource, $upload) {
    var ExerciseType = $resource(
      "/api/v1/exercise_types/:id.json",
      {},
      {paginationInfo: {method: 'GET', params: {mode: 'paginationInfo'}}}
    );

    ExerciseType.upload = function (exerciseType) {
      var fields = {name: exerciseType.name, short_name: exerciseType.short_name};
      if (exerciseType.id) {
        fields.id = exerciseType.id;
      }
      if (exerciseType.owner_id) {
        fields.owner_id = exerciseType.owner_id;
      }
      return $upload.upload({
        url: '/api/v1/exercise_types.json',
        file: exerciseType.image,
        fields: fields
      });
    };

    return ExerciseType;
  }]);