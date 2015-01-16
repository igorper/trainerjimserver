//= require auth/auth

angular.module('users', ['auth'])
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
  .controller('LoginPanelCtrl', ['$scope', '$window', 'Auth', function ($scope, $window, Auth) {
    $scope.isPanelVisible = false;
    $scope.isLoginActive = true;

    $scope.togglePanelVisibility = function () {
      $scope.isPanelVisible = !$scope.isPanelVisible;
    };

    $scope.toggleLoginActive = function () {
      $scope.isLoginActive = !$scope.isLoginActive;
    };

    $scope.loginSubmit = function () {
      Auth.login({
        email: $scope.loginEmail,
        password: $scope.loginPassword,
        rememberMe: $scope.loginRememberMe
      }, function () {
        $scope.onLoggedIn();
      }, function () {
        $window.alert("Could not log in. Check your email and password.");
      });
    };

    $scope.signUpSubmit = function () {
      Auth.signup({
        email: $scope.signUpEmail,
        password: $scope.signUpPassword,
        passwordConfirmation: $scope.signUpPasswordConfirmation
      }, function () {
        $window.alert("A confirmation email has been sent to your email. You will be able to log in through that email.");
        $scope.onLoggedIn();
      }, function () {
        $window.alert("Could not register. Please check your registration details.");
      });
    };
  }]);

