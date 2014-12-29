//= require apiLinks
//= require angular/angular.min
//= require angular-bootstrap/ui-bootstrap-tpls.min

angular
  .module('workouts.templates', [
    'ui.router',
    'ui.bootstrap'
  ])
  .config(['$stateProvider', '$urlRouterProvider', function ($stateProvider) {
    $stateProvider
      .state('workouts/templates', {
        url: "/workouts/templates",
        templateUrl: "workouts/templates/templates.html"
      });
  }]);