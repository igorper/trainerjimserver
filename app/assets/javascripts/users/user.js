angular
  .module("users", ["ngResource"])
  .factory("User", ["$resource", function ($resource) {
    return $resource("/api/v1/users/:id.json");
  }]);