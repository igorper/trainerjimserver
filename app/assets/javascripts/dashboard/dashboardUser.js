var dashboardUser = angular.module('dashboard.user', [
  'ui.router',
  'exerciseGroups.exerciseGroup',
  'util.promiseUi',
  'measurements.stats',
  'util.filters.withinPeriod'
]);

dashboardUser.controller('DashboardUserCtrl', ['$scope', 'Measurement', '$state', 'toaster', 'ExerciseGroup', '$q', 'MeasurementStats', function ($scope, Measurement, $state, toaster, ExerciseGroup, promise, MeasurementStats) {
    $scope.rightMenu = {items: []};

    $scope.statsPromise = promise
      .all({measurements: fetchMeasurements(), exerciseGroups: ExerciseGroup.query().$promise})
      .catch(overviewCalculationFailed)
      .then(function (fetchedData) {
        $scope.stats = MeasurementStats.calculateMeasurementListStats(fetchedData.measurements, fetchedData.exerciseGroups);
        return $scope.stats;
      });

    $scope.goToTrainingDetails = function (trainingId) {
      $state.go('main.dashboard.user.calendar.overview', {trainingId: trainingId});
    };

    function fetchMeasurements() {
      return Measurement.detailedMeasurementsForUser($state.params).$promise;
    }

    function overviewCalculationFailed() {
      toaster.pop("error", "Error while fetching measurements", "Unable to fetch measurements. An unexpected error occurred.");
    }
  }]
);