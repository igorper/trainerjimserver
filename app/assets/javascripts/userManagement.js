//= require angular.min.js
//= require api.js.erb
//= require pageLinks.js.erb

angular.module('userManagement', [])
  .directive('loginPanel', function () {
    return {
      restrict: 'E',
      scope: {},
      controller: function ($scope, $http, $window) {
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
            .post(api_v1_login_url, {email: $scope.loginEmail, password: $scope.loginPassword})
            .success(function (data, status, headers) {
              $window.location.href = workouts_url;
            })
            .error(function (data, status, headers) {
              $window.alert("Could not log in. Check your email and password.")
            });
        };
      },
      templateUrl: 'users/login-panel.html'
    };
  });

