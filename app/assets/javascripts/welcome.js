//= require apiLinks.js.erb
//= require angular.min.js
//= require ui-bootstrap-tpls-0.12.0.min.js
//= require userManagement

var welcomeApp = angular.module('welcome', ['userManagement']);

welcomeApp.controller('WelcomeCtrl', function ($scope) {

  $scope.onSignInButtonClicked = function (eventObject) {
    var button = eventObject.target;
    console.log(button);
  }

});