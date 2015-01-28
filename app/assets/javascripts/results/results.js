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
      .state('main.results', {
        url: "/results?:id",
        controller: "ResultsCtrl",
        templateUrl: "results/results.html"
      });
  }])
  .controller("ResultsCtrl", ["$scope", "$http", "Measurement", '$compile', 'uiCalendarConfig', '$stateParams', '$state',
    function ($scope, $http, Measurement, $compile, uiCalendarConfig, $stateParams, $state) {

      var SMILE_LOOKUP = {0: "bored", 1: "happy", 2: "sweat"};

      function getPlannedSeriesLookup(trainingPlan){
        var plannedSeries = _.flatten(_.pluck(trainingPlan, 'series'));
        return _.object (_.pluck(plannedSeries, 'id'), plannedSeries);
      }

      $scope.selectedTraining = null;
      $scope.calendarSources = [];

      $scope.trainingRatingIcon = null;
      $scope.durationInMinutes = null;
      $scope.performedSeries = null;
      $scope.totalSeries = null;
      $scope.averageRestDifferenceInSec = null;
      $scope.numberWeightChanges = null;
      $scope.averageWeightChanges = null;
      $scope.numberRepsChanges = null;
      $scope.averageRepsChanges = null;
      $scope.numSeriesTooHeavy = null;
      $scope.numSeriesTooEasy = null;

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

            $scope.calculateStatistics();
          }, function () {
            toaster.pop("error", "Fetch measurement error", "Unable to fetch the measurement");
          });
        }
      }

      $scope.calculateStatistics = function() {
        $scope.trainingRatingIcon = SMILE_LOOKUP[$scope.selectedTraining.rating] + "-on"
        $scope.durationInMinutes = (new Date($scope.selectedTraining.end_time) - new Date($scope.selectedTraining.start_time)) / (1000 * 60);
        $scope.performedSeries = $scope.selectedTraining.series_executions.length;
        $scope.totalSeries = _.flatten(_.pluck($scope.selectedTraining.exercises, 'series')).length;

        var lookupSeries = getPlannedSeriesLookup($scope.selectedTraining.exercises);

        var restDiff = 0;
        var cntDiffWeight = 0, sumDiffWeight = 0;
        var cntDiffReps = 0, sumDiffReps = 0;
        var cntHeavy = 0, cntEasy = 0;
        for (var i=0; i < $scope.selectedTraining.series_executions.length; i++){
          var se = $scope.selectedTraining.series_executions[i];
          var parentSeries = lookupSeries[se.series_id];

          // rest difference
          restDiff += Math.abs(parentSeries.rest_time - se.rest_time);

          // weight difference
          cntDiffWeight += se.weight - parentSeries.weight == 0 ? 0 : 1;
          sumDiffWeight += Math.abs(se.weight - parentSeries.weight);

          // reps difference
          cntDiffReps += se.num_repetitions - parentSeries.repeat_count == 0 ? 0 : 1;
          sumDiffReps += Math.abs(se.num_repetitions - parentSeries.repeat_count);

          // count too heavy and too easy
          cntHeavy += se.rating == 2 ? 1 : 0;
          cntEasy += se.rating == 0 ? 1 : 0;
        }

        $scope.averageRestDifferenceInSec = restDiff / $scope.selectedTraining.series_executions.length;
        $scope.numberWeightChanges = cntDiffWeight;
        $scope.averageWeightChanges = sumDiffWeight / cntDiffWeight;
        $scope.numberRepsChanges = cntDiffReps;
        $scope.averageRepsChanges = sumDiffReps / cntDiffReps;
        $scope.numSeriesTooHeavy = cntHeavy;
        $scope.numSeriesTooEasy = cntEasy;
      }

      $scope.alertOnEventClick = function (date, jsEvent, view) {
        $state.go('main.results', {id: date.training.id});
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