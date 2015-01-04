//= require apiLinks
//= require angular/angular
//= require angular-resource/angular-resource

angular
  .module("exercises", ["ngResource"])
  .factory("Exercise", ["$resource", function ($resource) {
    return $resource("/api/v1/exercises/:id.json");
  }]);