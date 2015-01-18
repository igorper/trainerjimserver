//= require angular-bootstrap/ui-bootstrap-tpls
//= require shared/shared
//= require angular-ui-grid/ui-grid

angular
  .module('trainees', [
    'ui.router',
    'ui.bootstrap',
    'shared',
    'ui.grid',
    'ui.grid.cellNav'
  ])
  .factory("Trainee", ["$resource", function ($resource) {
    return $resource("/api/v1/trainees/:id.json");
  }])
  .config(['$stateProvider', function ($stateProvider) {
    $stateProvider
      .state('trainees', {
        url: "/trainees",
        controller: "TraineesCtrl",
        templateUrl: "trainees/trainees.html"
      })
      .state('trainee', {
        url: "/trainees/:id",
        controller: "TraineeCtrl",
        templateUrl: "trainees/trainee.html"
      });
  }])
  .controller("TraineesCtrl", ["$scope", "$state", "Trainee", '$stateParams', 'toaster',
    function ($scope, $state, Trainee, $stateParams, toaster) {

      $scope.traineesGridConfig = {
        columnDefs: [
          {name: 'full_name', enableSorting: false},
          {name: 'email', enableSorting: false},
          {name: 'id', visible: false}
        ],
        onRegisterApi: function (gridApi) {
          $scope.traineesGridApi = gridApi;
          gridApi.cellNav.on.navigate($scope, function (newRowCol, oldRowCol) {
            $state.go('trainee', {id: newRowCol.row.entity.id});
          });
        }
      };

      function refreshTraineesList() {
        Trainee.query(function (trainees) {
          $scope.traineesGridConfig.data = trainees;
        }, function () {
          toaster.pop("error", "Trainees listing", "Could get the list of trainees. Try logging in again.");
        });
      }

      refreshTraineesList();
    }
  ])
  .controller("TraineeCtrl", ["$scope", "$state", "Trainee", '$stateParams', 'toaster',
    function ($scope, $state, Trainee, $stateParams, toaster) {
      Trainee.get({id: $stateParams.id}, function (trainee) {
        $scope.trainee = trainee;
      });
    }
  ])
;