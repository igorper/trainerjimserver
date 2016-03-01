//= require spin.js/spin
//= require lodash/lodash
//= require jquery/dist/jquery
//= require jquery-ui/jquery-ui
//= require touchpunch/touchpunch
//= require bootstrap/dist/js/bootstrap
//= require angular/angular
//= require angular-resource/angular-resource
//= require angular-ui-router/release/angular-ui-router
//= require angular-http-auth/src/http-auth-interceptor
//= require moment/moment
//= require angular-ui-calendar/src/calendar
//= require ng-file-upload/ng-file-upload
//= require angular-ui-select/dist/select
//= require fullcalendar/dist/fullcalendar
//= require fullcalendar/dist/gcal
//= require d3/d3
//= require angular-animate/angular-animate
//= require angular-sanitize/angular-sanitize
//= require angular-ui-sortable/sortable
//= require angular-cookies/angular-cookies
//= require angularjs-toaster/toaster
//= require angular-bootstrap/ui-bootstrap-tpls
//= require angular-translate/angular-translate
//= require angular-translate-storage-cookie/angular-translate-storage-cookie
//= require angular-translate-storage-local/angular-translate-storage-local
//= require nvd3/nv.d3
//= require angular-nvd3/dist/angular-nvd3
//= require intro.js/intro
//= require ngstorage/ngStorage
//= require_tree .

var trainerjimApp = angular.module('app', [
  'workouts',
  'trainees',
  'results',
  'shared',
  'http-auth-interceptor',
  'auth.loginDialog',
  'userProfile',
  'accounts',
  'dashboard'
]);

trainerjimApp.controller('MainBodyCtrl', ['$rootScope', 'LoginDialog', 'Auth', 'authService', function ($rootScope, LoginDialog, Auth, authService) {
  $rootScope.$on('event:auth-loginRequired', function () {
    var loginDialog = LoginDialog();
    if (loginDialog != null) {
      loginDialog.result.then(function (credentials) {
        Auth.login(credentials, function () {
          authService.loginConfirmed();
        });
      }, function () {
        authService.loginCancelled();
      });
    }
  });
}]);

trainerjimApp.config(['$stateProvider', function ($stateProvider) {
  $stateProvider.state('main', {
    abstract: true,
    url: "",
    views: {
      'body': {template: '<div class="jim-body"><ui-view></ui-view></div>', controller: 'MainBodyCtrl'},
      'header': {template: '<header></header>'},
      'footer': {template: '<footer></footer>'}
    }
  });

  document.megaSpinner.stop();
}]);

trainerjimApp.config(['$urlRouterProvider', function ($urlRouterProvider) {
  $urlRouterProvider.otherwise("/workouts/instructions");
}]);
