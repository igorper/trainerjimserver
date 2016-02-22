var dashboardUserSummary = angular.module('dashboard.user.summary', [
  'ui.router',
  'nvd3'
]);

dashboardUserSummary.controller('DashboardUserSummaryCtrl', ['$scope', '$state', 'MeasurementStats', function ($scope, $state, MeasurementStats) {
  $scope.sortType = "date";
  $scope.sortReverse = true;
  $scope.periodName = $state.params.filter;
  $scope.filteredMeasurementsNotEmpty = true;

  // CAUTION: if changing this take a look at the recalculatePieChartData function
  $scope.rightMenu.items = [
    {
      name: "All",
      link: getSummaryLink('all')
    },
    {
      name: "Last month",
      link: getSummaryLink('month')
    },
    {
      name: "Last week",
      link: getSummaryLink('week')
    },
    {
      name: "Last 24 hours",
      link: getSummaryLink('day')
    }
  ];

  function getSummaryLink(filter) {
    return $scope.userDashboardOptions.statePrefix + ".user.summary({filter: '" + filter + "'})"
  }

  function recalculatePieChartData(fetchedData){
    // currently all the periodName filter vales are legal moment subtract types
    // (if another period type is added it should either be check if it is still valid for use with moment subtract
    // or mapped to a valid moment subtract value)
    var momentDateSubtractType = $scope.periodName;

    if($scope.periodName !== 'all'){
      var filteredMeasurements = _.filter(fetchedData.measurements, function(measurement) { return moment(measurement.start_time).isAfter(moment().subtract(1, momentDateSubtractType)); })

      $scope.filteredMeasurementsNotEmpty = filteredMeasurements.length > 0;

      $scope.filteredPieChartCounts = MeasurementStats.calculateMeasurementListStats(filteredMeasurements, fetchedData.exerciseGroups);
    } else {
      $scope.filteredPieChartCounts = MeasurementStats.calculateMeasurementListStats(fetchedData.measurements, fetchedData.exerciseGroups);
    }


  }

  $scope.statsPromise.then(function(){
    recalculatePieChartData($scope.measurementsAndExerciseGroups);
  });

  $scope.executedExerciseGroupsPieChartOptions = {
    chart: {
      type: 'pieChart',
      x: function (d) {
        return d.exerciseGroup.name;
      },
      y: function (d) {
        return d.count;
      },
      showLabels: true,
      transitionDuration: 500,
      height: 300,
      tooltips: false,
      labelType: 'percent',
      legend: {
        updateState: false
      }
    }
  };
}]);