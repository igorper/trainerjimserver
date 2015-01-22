//= require angular-resource/angular-resource

var authModule = angular.module("auth", ["ngResource"]);

authModule.factory("Auth", ["$resource", function ($resource) {
  return $resource("/api/v1/auth/:action", null,
    {
      login: {method: 'POST', params: {action: 'login'}},
      signup: {method: 'POST', params: {action: 'signup'}},
      logout: {method: 'POST', params: {action: 'logout'}},
      username: {method: 'GET', params: {action: 'username'}},
      isLoggedIn: {method: 'GET', params: {action: 'is_logged_in'}}
    });
}]);