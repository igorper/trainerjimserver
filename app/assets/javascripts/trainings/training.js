//= require angular-resource/angular-resource

angular
  .module("trainings", ["ngResource"])
  .factory("Training", ["$resource", function ($resource) {
    return $resource("/api/v1/trainings/:id.json");
  }]);