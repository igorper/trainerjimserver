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

      $http.get(api_trainings_url)
        .success(function (data, status, headers) {
          $scope.templates = data;
        })
        .error(function (data, status, headers) {
          $window.alert("Could not log in. Check your email and password.")
        });

      var tmpList = [];

      for (var i = 1; i <= 6; i++){
        tmpList.push({
          text: 'Item ' + i,
          value: i
        });
      }

      $scope.list = tmpList;


      $scope.sortingLog = [];

      $scope.sortableOptions = {
        update: function (e, ui) {
          var logEntry = tmpList.map(function (i) {
            return i.value;
          }).join(', ');
          $scope.sortingLog.push('Update: ' + logEntry);
        },
        stop: function (e, ui) {
          // this callback has the changed model
          var logEntry = tmpList.map(function (i) {
            return i.value;
          }).join(', ');
          $scope.sortingLog.push('Stop: ' + logEntry);
        }
      }

    }
  ])
;