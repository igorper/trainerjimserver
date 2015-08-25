var dashboardUserCalendar = angular.module('dashboard.user.calendar', [
  'ui.router'
]);

dashboardUserCalendar.controller('DashboardUserCalendarCtrl', ['$scope', 'Measurement', '$state', function ($scope, Measurement, $state) {
  $scope.smileLookupCssClass = {};
  $scope.smileLookupCssClass[Measurement.TOO_HARD_RATING] = "sweat";
  $scope.smileLookupCssClass[Measurement.OKAY_RATING] = "happy";
  $scope.smileLookupCssClass[Measurement.TOO_EASY_RATING] = "bored";

  $scope.selectedTraining = null;
  $scope.calendarSources = [];

  $scope.isTrainingSelected = $state.params.trainingId !== "";

  $scope.populateRightMenu([
    {
      name: "Overview",
      link: "main.dashboard.user.calendar.overview"
    },
    {
      name: "Details",
      link: "main.dashboard.user.calendar.details"
    }
  ], $scope.isTrainingSelected);

  $scope.statsPromise.then(function (data) {
    // populate the calendar input source
    for (var i = 0; i < data.measurementsStats.length; i++) {
      var measurement = data.measurementsStats[i].measurement;
      $scope.calendarSources.push([{
        start: new Date(measurement.start_time),
        end: new Date(measurement.end_time),
        className: 'smile-icon',
        training: measurement
      }]);
    }

    if($scope.isTrainingSelected) {
      // also store the currently selected training in a variable
      $scope.selectedTraining = _.find(data.measurementsStats, function(item) {return item.measurement.id === parseInt($state.params.trainingId);});

      // and make the calendar stay on the page with the selected training
      $scope.uiConfig.calendar['defaultDate'] = $scope.selectedTraining.date;
    }
  });

  $scope.alertOnEventClick = function (date, jsEvent, view) {
    $state.go('main.dashboard.user.calendar.overview', {trainingId: date.training.id});
  };

  /* Render Tooltip */
  $scope.eventRender = function (event, element, view) {
    // TODO: tooltip
    //element.attr({'tooltip': event.title,
    //  'tooltip-append-to-body': true});
    //$compile(element)($scope);

    var smileyStatus = parseInt($state.params.trainingId) === event.training.id ? "on" : "off";
    element.find(".fc-content").addClass($scope.smileLookupCssClass[event.training.rating] + "-" + smileyStatus);
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
}]);