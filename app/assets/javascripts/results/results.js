//= require apiLinks
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
        url: "/results",
        controller: "ResultsCtrl",
        templateUrl: "results/results.html"
      });
  }])
  .controller("ResultsCtrl", ["$scope", "$http", "Measurement", '$compile','uiCalendarConfig',
    function($scope, $http, Measurement, $compile, uiCalendarConfig){

      $scope.selectedTraining = null;
      $scope.calendarSources = [];

      Measurement.query(function (data) {
        $scope.results = data;

        for(var i=0; i < $scope.results.length; i++){
          var r = $scope.results[i];
          $scope.calendarSources.push([{start: new Date(r.start_time), end: new Date(r.end_time), title: r.id.toString(), training: r}])
        }

      }, function (data, status, headers) {
        console.error("Could not fetch exercises.");
      });

      $scope.alertOnEventClick = function( date, jsEvent, view){
        $scope.selectedTraining = date;
        uiCalendarConfig.calendars["myCalendar1"].fullCalendar("render");
      };

      /* Render Tooltip */
      $scope.eventRender = function( event, element, view ) {
        // TODO: tooltip
        //element.attr({'tooltip': event.title,
        //  'tooltip-append-to-body': true});
        //$compile(element)($scope);

        if($scope.selectedTraining && $scope.selectedTraining._id === event._id)
          element.addClass("selectedTraining");
      };
      $scope.uiConfig = {
        calendar:{
          height: 550,
          header:{
            right: 'today prev,next'
          },
          eventClick: $scope.alertOnEventClick,
          eventRender: $scope.eventRender
        }
      };
    }
  ])
;