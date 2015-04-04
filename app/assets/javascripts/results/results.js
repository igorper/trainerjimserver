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
        url: "/results?:id&trainee",
        controller: "ResultsCtrl",
        templateUrl: "results/results.html"
      });
  }])
  .controller("ResultsCtrl", ["$scope", "$http", "Measurement", '$compile', 'uiCalendarConfig', '$stateParams', '$state',
    "toaster", "Trainee", "Auth",
    function ($scope, $http, Measurement, $compile, uiCalendarConfig, $stateParams, $state, toaster, Trainee, Auth) {
      $scope.smileLookup = {0: "bored", 1: "happy", 2: "sweat"};

      /**
       * Create a lookup table for planned series. Each series can be looked up by it's id, which is also stored
       * for each series execution. Besides each series data id of the parent exercise is added to retain the information
       * of the exercise the series belongs to.
       * @param trainingPlan
       * @returns {Array}
       */
      function getPlannedSeriesLookup(trainingPlan){
        var lookup = [];
        for(var i=0; i < trainingPlan.length; i++){
          var exercise = trainingPlan[i];
          for(var j=0; j < exercise.series.length; j++){
            var series = exercise.series[j];
            series['exercise_id'] = exercise.exercise_type.id;
            lookup[series.id] = series;
          }
        }
        return lookup;
      }

      function getSeriesExecutionsLookup(series_executions){
        return _.object(_.pluck(series_executions, "series_id"), series_executions);
      }

      var lookupSeries = null;
      var lookupSeriesExecutions = null;

      $scope.userDetails = null;
      $scope.selectedTraining = null;
      $scope.trainingPage = null;
      $scope.calendarSources = [];

      $scope.trainingRatingIcon = null;
      $scope.durationInMinutes = null;
      $scope.totalRestInMinutes = null;
      $scope.totalExercisesInMinutes = null;
      $scope.numExercisesPlanned = null;
      $scope.numExercisesPerformed = null;
      $scope.performedSeries = null;
      $scope.totalSeries = null;
      $scope.averageRestDifferenceInSec = null;
      $scope.numberWeightChanges = null;
      $scope.averageWeightChanges = null;
      $scope.numberRepsChanges = null;
      $scope.averageRepsChanges = null;
      $scope.numSeriesTooHeavy = null;
      $scope.numSeriesTooEasy = null;

      $scope.user = {};
      $scope.users = [];

      Trainee.query(function (trainees) {
        $scope.users = trainees;
        if($stateParams.trainee){
         $scope.user.selected = _.find($scope.users, function(u) { return u.id == parseInt($stateParams.trainee)});
        }
      }, function () {
        toaster.pop("error", "Trainees listing", "Could get the list of trainees. Try logging in again.");
      });

      if ($stateParams.id != undefined) {
        if ($stateParams.id) {
          Measurement.get({id: $stateParams.id}, function (measurement) {
            $scope.selectedTraining = measurement;

            // show the calendar for the selected training date
            $scope.uiConfig.calendar['defaultDate'] = $scope.selectedTraining.start_time;
            //uiCalendarConfig.calendars["myCalendar1"].fullCalendar("render");

            $scope.trainingPage = "Overview";

            lookupSeries = getPlannedSeriesLookup($scope.selectedTraining.exercises);
            lookupSeriesExecutions = getSeriesExecutionsLookup($scope.selectedTraining.series_executions);


            $scope.calculateOverview();
          }, function () {
            toaster.pop("error", "Fetch measurement error", "Unable to fetch the measurement");
          });
        }
      }

      Auth.userDetails(function (userDetails) {
        $scope.userDetails = userDetails;
        Measurement.query({trainer: userDetails.is_trainer, trainee_id: $stateParams.trainee == undefined ? null : $stateParams.trainee}, function (data) {
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
      });

      $scope.onTraineeChanged = function(item, model){
        if($scope.user.selected != item){
          $state.go('main.results', {id: undefined, trainee: item == undefined ? null : item.id});
        }
      }

      $scope.calculateOverview = function() {
        $scope.trainingRatingIcon = $scope.smileLookup[$scope.selectedTraining.rating] + "-on"
        $scope.durationInMinutes = (new Date($scope.selectedTraining.end_time) - new Date($scope.selectedTraining.start_time)) / (1000 * 60);

        $scope.numExercisesPlanned = _.unique(_.pluck(_.pluck($scope.selectedTraining.exercises, 'exercise_type'), 'id')).length;
        $scope.performedSeries = $scope.selectedTraining.series_executions.length;
        $scope.totalSeries = _.flatten(_.pluck($scope.selectedTraining.exercises, 'series')).length;

        var performedSeriesExerciseId = [];
        var restInSeconds = 0, exerciseInSeconds = 0;
        var restDiff = 0;
        var cntDiffWeight = 0, sumDiffWeight = 0;
        var cntDiffReps = 0, sumDiffReps = 0;
        var cntHeavy = 0, cntEasy = 0;
        for (var i=0; i < $scope.selectedTraining.series_executions.length; i++){

          // encode order into the series execution
          $scope.selectedTraining.series_executions[i].order = i + 1;

          var se = $scope.selectedTraining.series_executions[i];
          var parentSeries = lookupSeries[se.series_id];

          performedSeriesExerciseId.push(parentSeries.exercise_id);

          // calculate rest and exercise time
          restInSeconds += $scope.selectedTraining.series_executions[i].rest_time;
          exerciseInSeconds += $scope.selectedTraining.series_executions[i].duration_seconds;

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

        $scope.numExercisesPerformed = _.unique(performedSeriesExerciseId).length;
        $scope.totalRestInMinutes = restInSeconds / 60.0;
        $scope.totalExercisesInMinutes = exerciseInSeconds / 60.0;
        $scope.averageRestDifferenceInSec = restDiff / $scope.selectedTraining.series_executions.length;
        $scope.numberWeightChanges = cntDiffWeight;
        $scope.averageWeightChanges = cntDiffWeight == 0 ? 0 : sumDiffWeight / cntDiffWeight;
        $scope.numberRepsChanges = cntDiffReps;
        $scope.averageRepsChanges = cntDiffReps == 0 ? 0 : sumDiffReps / cntDiffReps;
        $scope.numSeriesTooHeavy = cntHeavy;
        $scope.numSeriesTooEasy = cntEasy;
      }

      $scope.getSeriesExecution = function(id){
        return lookupSeriesExecutions[id];
      }

      $scope.getRestLabel = function(series){
        return $scope.getSeriesExecution(series.id) ? $scope.getSeriesExecution(series.id).rest_time + "/" + series.rest_time : "";
      }

      $scope.getRepsLabel = function(series){
        return $scope.getSeriesExecution(series.id) ? $scope.getSeriesExecution(series.id).num_repetitions + "/" + series.repeat_count : "";
      }

      $scope.getWeightLabel = function(series){
        return $scope.getSeriesExecution(series.id) ? $scope.getSeriesExecution(series.id).weight + "/" + series.weight : "";
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
        element.find(".fc-content").addClass($scope.smileLookup[event.training.rating] + "-" + smileyStatus);
        element.find(".fc-content").empty();

      };
      $scope.uiConfig = {
        calendar: {
          height: 450,
          header: {
            right: 'today prev,next'
          },
          eventClick: $scope.alertOnEventClick,
          eventRender: $scope.eventRender
        }
      };
    }
  ])
  .directive('ghVisualization', [function () {

    // constants
    var width = 100;

    return {
      restrict: 'E',
      scope: {
        rest: '=',
        expected: '=',
        actual: '=',
        label: '='
      },
      link: function (scope, element, attrs) {
        // set up initial svg object
        var chart = d3.select(element[0])
          .append("svg")
          .attr("class", "chart")
          .attr("width", width)
          .attr("height", 30);

        var ex, ac, rest, label;

        function refreshBar(){
          if(ex === undefined || ac === undefined || rest === undefined){
            return;
          }

          var scale = d3.scale.linear()
            .domain([0, d3.max([ex, ac])])
            .range([0, width]);

          // draw the blue box representing the expected quantity
          chart.append("svg:rect")
            .attr("class", "blue")
            .attr("width", scale(ex))
            .attr("height", 30);

          // draw the box visualizing the deviation from the expected quantity
          chart.append("svg:rect")
            .attr("class", rest ? (ac < ex ? "green" : "red") : (ac < ex ? "red" : "green"))
            .attr("x", scale(ac < ex ? ac : ex))
            .attr("y", 1)
            .attr("width", scale(ac < ex ? ex : ac))
            .attr("height", 28);

          // draw the vertical line that visualizes the expected quantity
          var xLine = scale(ex) == 0 ? scale(ex) +2 : (scale(ex) == width ? scale(ex) - 2 : scale(ex));
          chart.append("line")
            .attr("x1", xLine)
            .attr("y1", 0)
            .attr("x2", xLine)
            .attr("y2", 30)
            .attr("stroke-width", 4)
            .attr("stroke", "black");

          chart.append("text")
            .attr("x", 20)
               .attr("y", 21)
               .text(label)
               .attr("font-size", "20px")
             .attr("font-weigth", "bold")
               .attr("fill", "white");

          // write the text with the actual and expected quantity
        }

        scope.$watch('expected', function (newVal, oldVal) {

          if(newVal === undefined){
            return;
          }

          ex = newVal;

          refreshBar();
        });

        scope.$watch('actual', function (newVal, oldVal) {

          if(newVal === undefined){
            return;
          }

          ac = newVal;

          refreshBar();
        });

        scope.$watch('rest', function (newVal, oldVal) {

          if(newVal === undefined){
            return;
          }

          rest = newVal;

          refreshBar();
        });

        scope.$watch('label', function (newVal, oldVal) {

          if(newVal === undefined){
            return;
          }

          label = newVal;

          refreshBar();
        });

      }
    }
  }]);