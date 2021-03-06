var users = angular.module('users', [
  'ngResource',
  'ngFileUpload'
]);

var USER_CHANGED_EVENT = 'event:user.changed';

users.factory('currentUserChanged', ['$rootScope', function ($rootScope) {
  return function (successCallback) {
    return function (userDetails) {
      $rootScope.$broadcast(USER_CHANGED_EVENT, userDetails);
      if (successCallback) {
        successCallback(userDetails);
      }
    };
  };
}]);

users.factory('User', ['$resource', '$rootScope', 'currentUserChanged', 'Upload', '$q', function ($resource, $rootScope, currentUserChanged, Upload, $q) {
  var User = $resource('/api/v1/users/:id.json', {id: '@id'}, {
    confirm: {method: 'POST', url: '/api/v1/users/confirm.json'},
    confirmUserDetails: {method: 'POST', url: '/api/v1/users/confirm_user_details.json'},
    currentImpl: {method: 'GET', url: '/api/v1/users/current.json'},
    setNameImpl: {method: 'POST', url: '/api/v1/users/:id/name.json'},
    setPasswordImpl: {method: 'POST', url: '/api/v1/users/:id/password.json'}
  });

  User.setName = function (params, successCallback, failureCallback) {
    return User.setNameImpl(params, currentUserChanged(successCallback), failureCallback)
  };

  User.setPassword = function (params, successCallback, failureCallback) {
    return User.setPasswordImpl(params, currentUserChanged(successCallback), failureCallback)
  };

  User.create = function (user, photo) {
    return $q(function (resolve, reject) {
      Upload.upload({
        url: '/api/v1/users.json',
        method: 'POST',
        fields: user,
        file: photo
      }).then(function (response) {
        resolve(new User(response.data));
      }, reject);
    });
  };

  User.current = function (successCallback, failureCallback) {
    if (_.isUndefined(User.cachedCurrentUser)) {
      User.cachedCurrentUser = User.currentImpl();
    }
    User.cachedCurrentUser.$promise.then(successCallback, failureCallback);
    return User.cachedCurrentUser;
  };

  $rootScope.$on(USER_CHANGED_EVENT, function (event, updatedUser) {
    User.cachedCurrentUser = undefined;
  });

  return User;
}]);