//= require angular-bootstrap/ui-bootstrap-tpls
//= require shared/shared
//= require measurements/measurement

angular
  .module('results', [
    'ui.router',
    'ui.bootstrap',
    'shared',
    'ui.calendar',
    'measurements'
  ])
  .config(['$stateProvider', '$urlRouterProvider', function ($stateProvider) {
    $stateProvider
      .state('results', {
        url: "/results?:id",
        views: {
          body: {
            controller: "ResultsCtrl",
            templateUrl: "results/results.html"
          },
          header: {templateUrl: 'shared/header-view.html'},
          footer: {templateUrl: 'shared/footer-view.html'}
        }
      });
  }])
  .controller("ResultsCtrl", ["$scope", "$http", "Measurement", '$compile', 'uiCalendarConfig', '$stateParams', '$state',
    function ($scope, $http, Measurement, $compile, uiCalendarConfig, $stateParams, $state) {

      var SMILE_LOOKUP = {0: "bored", 1: "happy", 2: "sweat"};

      $scope.selectedTraining = null;
      $scope.calendarSources = [];

      Measurement.query(function (data) {
        $scope.results = data;

        for (var i = 0; i < $scope.results.length; i++) {
          var r = $scope.results[i];
          $scope.calendarSources.push([{
            start: new Date(r.start_time),
            end: new Date(r.end_time),
            className: 'smile-icon',
            training: r
          }])
        }

      }, function (data, status, headers) {
        console.error("Could not fetch exercises.");
      });

      if ($stateParams.id != undefined) {
        if ($stateParams.id) {
          Measurement.get({id: $stateParams.id}, function (measurement) {
            $scope.selectedTraining = measurement;
            uiCalendarConfig.calendars["myCalendar1"].fullCalendar("render");
          }, function () {
            toaster.pop("error", "Fetch measurement error", "Unable to fetch the measurement");
          });
        }
      }

      $scope.durationInMinutes = function () {
        return $scope.selectedTraining ? (new Date($scope.selectedTraining.end_time) - new Date($scope.selectedTraining.start_time)) / (1000 * 60) : 0;
      }

      $scope.alertOnEventClick = function (date, jsEvent, view) {
        $state.go('results', {id: date.training.id});
      };

      /* Render Tooltip */
      $scope.eventRender = function (event, element, view) {
        // TODO: tooltip
        //element.attr({'tooltip': event.title,
        //  'tooltip-append-to-body': true});
        //$compile(element)($scope);

        var smileyStatus = $scope.selectedTraining && $scope.selectedTraining.id === event.training.id ? "on" : "off";
        element.addClass(SMILE_LOOKUP[event.training.rating] + "-" + smileyStatus);

      };
      $scope.uiConfig = {
        calendar: {
          header: {
            right: 'today prev,next'
          },
          eventClick: $scope.alertOnEventClick,
          eventRender: $scope.eventRender
        }
      };
    }
  ]);