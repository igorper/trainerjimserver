var users = angular.module('users', ['ngResource']);

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

users.factory('User', ['$resource', 'currentUserChanged', function ($resource, currentUserChanged) {
  var User = $resource('/api/v1/users/:id.json', {id: '@id'}, {
    current: {method: 'GET', url: '/api/v1/users/current.json'},
    setNameImpl: {method: 'POST', url: '/api/v1/users/:id/name.json'},
    setPasswordImpl: {method: 'POST', url: '/api/v1/users/:id/password.json'}
  });

  User.setName = function (params, successCallback, failureCallback) {
    return User.setNameImpl(params, currentUserChanged(successCallback), failureCallback)
  };

  User.setPassword = function (params, successCallback, failureCallback) {
    return User.setPasswordImpl(params, currentUserChanged(successCallback), failureCallback)
  };

  return User;
}]);