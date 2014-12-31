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
      var REPETITIONS_STEP = 1;
      var WEIGHT_STEP = 5;
      var REST_STEP = 5;

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

      $scope.getSelectedSeries = function(exercise){
        return exercise.series[exercise.selectedSeries];
      }

      $scope.increaseSeriesRepetitions = function(exercise){
        $scope.getSelectedSeries(exercise).repeat_count += REPETITIONS_STEP;
      }

      $scope.decreaseSeriesRepetitions = function(exercise){
        var series = $scope.getSelectedSeries(exercise);
        series.repeat_count = series.repeat_count < REPETITIONS_STEP ? 0 : series.repeat_count - REPETITIONS_STEP;
      }

      $scope.increaseSeriesWeight = function(exercise){
        $scope.getSelectedSeries(exercise).weight += WEIGHT_STEP;
      }

      $scope.decreaseSeriesWeight = function(exercise){
        var series = $scope.getSelectedSeries(exercise);
        series.weight = series.weight < WEIGHT_STEP ? 0 : series.weight - WEIGHT_STEP;
      }

      $scope.increaseSeriesRest = function(exercise){
        $scope.getSelectedSeries(exercise).rest_time += REST_STEP;
      }

      $scope.decreaseSeriesRest = function(exercise){
        var series = $scope.getSelectedSeries(exercise);
        series.rest_time = series.rest_time < REST_STEP ? 0 : series.rest_time - REST_STEP;
      }
    }
  ])
;