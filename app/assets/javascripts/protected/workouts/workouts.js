//= require apiLinks
//= require angular-ui-sortable


angular
  .module('protected.workouts', [
    'ui.router',
    'ui.bootstrap',
    'ui.sortable'
  ])
  .config(['$stateProvider', '$urlRouterProvider', function ($stateProvider) {
    $stateProvider
      .state('protected.workouts', {
        url: "/workouts",
        controller: "WorkoutsCtrl",
        templateUrl: "protected/workouts/workouts.html"
      });
  }])
  .controller("WorkoutsCtrl", ["$scope", "$http", "$window",
    function($scope, $http, $window){
      $scope.test = "WORKOUTS";

      $scope.templates = [];
      $scope.selectedTraining = null;
      $scope.selectedSeries = [];

      $http.get(api_trainings_url)
        .success(function (data, status, headers) {
          $scope.templates = data;
        })
        .error(function (data, status, headers) {
          $window.alert("Could not log in. Check your email and password.")
        });

      $scope.showTemplate = function(template){
        $http.get(api_training_url, {params:{id: template.id}})
          .success(function (data, status, headers) {
          $scope.selectedTraining = data;
            $scope.selectedSeries = [];

            // select default series to show for each exercise
            for(var i = 0; i < data.exercises.length; i++){
              data.exercises[i].selectedSeries = 0;
            }

          })
          .error(function (data, status, headers) {
            $window.alert("Unable to fetch the training.")
          });

        console.log(template);
      }

      $scope.createEmptyTraining = function(){
        $scope.selectedTraining = {
          name: "Enter training name"
        }
      }

      $scope.changeSelectedSeries = function(exercise, seriesIdx){
        exercise.selectedSeries = seriesIdx;
      }

      $scope.sortableOptions = {
        handle: '.move'
      };
    }
  ])
;