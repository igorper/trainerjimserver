angular
  .module("exerciseTypes.exerciseType", ["ngResource"])
  .factory("ExerciseType", ["$resource", '$upload', function ($resource, $upload) {
    var ExerciseType = $resource("/api/v1/exercise_types/:id.json");

    ExerciseType.upload = function (exerciseType) {
      return $upload.upload({
        url: '/api/v1/exercise_types.json',
        file: exerciseType.image,
        fields: {name: exerciseType.name}
      });
    };

    return ExerciseType;
  }]);