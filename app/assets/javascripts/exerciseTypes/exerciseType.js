angular
  .module("exerciseTypes.exerciseType", ["ngResource"])
  .factory("ExerciseType", ["$resource", '$upload', function ($resource, $upload) {
    var ExerciseType = $resource("/api/v1/exercise_types/:id.json");

    ExerciseType.upload = function (data) {
      return $upload.upload({
        url: '/api/v1/exercise_types.json',
        file: data.image,
        fields: {name: data.name}
      });
    };

    return ExerciseType;
  }]);