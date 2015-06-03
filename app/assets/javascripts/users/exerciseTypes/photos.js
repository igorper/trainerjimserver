angular.module("users.exerciseTypes.photos", ["ngResource", 'ngFileUpload'])
  .factory("UserExerciseTypePhotos", ["$resource", 'Upload', function ($resource, Upload) {
    var UserExerciseTypePhotos = $resource("/api/v1/users/:userId/exercise_types/:exerciseTypeId/photos/:photoId.json", null, {
    });

    UserExerciseTypePhotos.add = function (userId, exerciseTypeId, photo) {
      return Upload.upload({
        url: '/api/v1/users/' + userId + '/exercise_types/' + exerciseTypeId + '/photos',
        method: 'POST',
        file: photo
      });
    };

    return UserExerciseTypePhotos;
  }]);