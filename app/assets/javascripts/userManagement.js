//= require angular.min.js
//= require api.js.erb

angular.module('userManagement', [])
  .directive('loginPanel', function () {
    return {
      restrict: 'E',
      scope: {},
      controller: function ($scope, $http) {
        $scope.isPanelVisible = false;
        $scope.isLoginActive = true;

        $scope.togglePanelVisibility = function () {
          $scope.isPanelVisible = !$scope.isPanelVisible;
        };

        $scope.toggleLoginActive = function () {
          $scope.isLoginActive = !$scope.isLoginActive;
        };

        $scope.loginSubmit = function () {
          $http
            .post(api_v1_login_url)
            .success(function (data, status, headers) {
              console.log("Successfully logged in.");
            })
            .error(function (data, status, headers) {
              console.error("Could not log in.");
            });
        };
      },
      templateUrl: 'users/login-panel.html'
    };
  });

