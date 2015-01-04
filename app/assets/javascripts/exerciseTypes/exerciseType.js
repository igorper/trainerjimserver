//= require apiLinks
//= require angular/angular
//= require angular-resource/angular-resource

angular
  .module("exerciseTypes", ["ngResource"])
  .factory("ExerciseType", ["$resource", function ($resource) {
    return $resource("/api/v1/exercise_types/:id.json");
  }]);