//= require apiLinks.js.erb
//= require angular.min.js
//= require ui-bootstrap-tpls-0.12.0.min.js
//= require userManagement

var welcomeApp = angular.module('welcome', ['userManagement', 'ui.bootstrap']);

welcomeApp.controller('WelcomeCtrl', function ($scope) {

});