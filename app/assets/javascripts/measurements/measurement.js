//= require apiLinks
//= require angular-resource/angular-resource

angular
  .module("measurements", ["ngResource"])
  .factory("Measurement", ["$resource", function ($resource) {
    return $resource("/api/v1/measurements/:id.json");
  }]);