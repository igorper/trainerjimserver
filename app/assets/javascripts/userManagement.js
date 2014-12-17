//= require angular.min.js

angular.module('userManagement', [])
  .directive('loginPanel', function() {
    return {
      restrict: 'E',
      scope: {},
      controller: function ($scope) {
        $scope.isPanelVisible = false;
        $scope.isLoginActive = true;

        $scope.togglePanelVisibility = function () {
          $scope.isPanelVisible = !$scope.isPanelVisible;
        };

        $scope.toggleLoginActive = function () {
          $scope.isLoginActive = !$scope.isLoginActive;
        };
      },
      templateUrl: 'users/login-panel.html'
    };
  });

