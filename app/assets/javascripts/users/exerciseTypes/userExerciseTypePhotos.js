var userExerciseTypePhotos = angular.module('users.exerciseTypes.photos', ['ngResource', 'ngFileUpload']);

userExerciseTypePhotos.factory('UserExerciseTypePhotos', ['$resource', 'Upload', function ($resource, Upload) {
  var UserExerciseTypePhotos = $resource('/api/v1/user_exercise_photos/:id.json',
    {id: '@id'},
    {
      query: {
        method: 'GET',
        isArray: true,
        params: {userId: '@user_id', exerciseTypeId: '@exercise_type_id'},
        url: '/api/v1/users/:userId/exercise_types/:exerciseTypeId/photos/:photoId.json'
      },
      primaryPhotos: {
        method: 'GET',
        isArray: true,
        params: {},
        url: '/api/v1/users/exercise_types/primary_photos.json'
      }
    }
  );

  UserExerciseTypePhotos.add = function (userId, exerciseTypeId, photo) {
    return Upload.upload({
      url: '/api/v1/users/' + userId + '/exercise_types/' + exerciseTypeId + '/photos.json',
      method: 'POST',
      file: photo
    });
  };

  return UserExerciseTypePhotos;
}]);