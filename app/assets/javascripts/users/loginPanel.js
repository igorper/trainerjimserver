//= require apiLinks
//= require pageLinks

angular.module('users', [])
  .directive('loginPanel', function () {
    return {
      restrict: 'E',
      scope: {
        'onLoggedIn': '&onLoggedIn'
      },
      controller: 'LoginPanelCtrl',
      templateUrl: 'users/login-panel.html'
    };
  })
  .controller('LoginPanelCtrl', ['$scope', '$http', '$window', function ($scope, $http, $window) {
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
        .post(api_login_url, {
          email: $scope.loginEmail,
          password: $scope.loginPassword,
          rememberMe: $scope.loginRememberMe
        })
        .success(function (data, status, headers) {
          $scope.onLoggedIn();
        })
        .error(function (data, status, headers) {
          $window.alert("Could not log in. Check your email and password.")
        });
    };

    $scope.signUpSubmit = function () {
      $http
        .post(api_sign_up_url, {
          email: $scope.signUpEmail,
          password: $scope.signUpPassword,
          passwordConfirmation: $scope.signUpPasswordConfirmation
        })
        .success(function (data, status, headers) {
          $window.alert("A confirmation email has been sent to your email. You will be able to log in through that email.");
          $scope.onLoggedIn();
        })
        .error(function (data, status, headers) {
          $window.alert("Could not register. Please check your registration details.");
        });
    };
  }]);

