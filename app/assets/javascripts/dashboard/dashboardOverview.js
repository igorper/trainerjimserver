var dashboardOverview = angular.module('dashboard.overview', [
  'ui.router',
  'nvd3',
  'exerciseGroups.exerciseGroup',
  'util.promiseUi',
  'measurements.stats',
  'util.filters.withinPeriod'
]);


dashboardOverview.controller('DashboardOverviewCtrl', ['$scope', 'Measurement', '$state', 'toaster', 'ExerciseGroup', '$q', 'MeasurementStats', function ($scope, Measurement, $state, toaster, ExerciseGroup, promise, MeasurementStats) {
    $scope.sortType = "date";
    $scope.sortReverse = false;
    $scope.periodName = "all";

    $scope.statsPromise = promise
      .all({measurements: fetchMeasurements(), exerciseGroups: ExerciseGroup.query().$promise})
      .catch(overviewCalculationFailed)
      .then(function (fetchedData) {
        $scope.stats = MeasurementStats.calculateMeasurementListStats(fetchedData.measurements, fetchedData.exerciseGroups);
      });

    function fetchMeasurements() {
      return Measurement.detailedMeasurements().$promise;
    }

    function overviewCalculationFailed() {
      toaster.pop("error", "Error while fetching measurements", "Unable to fetch measurements. An unexpected error occurred.");
    }

    $scope.goToResults = function (measurement) {
      $state.go('main.results', {trainee: measurement.trainee_id, id: measurement.id});
    };

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
        height: 300
      }
    };
  }]
);