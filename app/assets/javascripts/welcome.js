//= require apiLinks.js.erb
//= require angular.min.js
//= require userManagement

var welcomeApp = angular.module('welcome', ['userManagement']);

welcomeApp.controller('WelcomeCtrl', function ($scope) {

  $scope.onSignInButtonClicked = function (eventObject) {
    var button = eventObject.target;
    console.log(button);
  }

});