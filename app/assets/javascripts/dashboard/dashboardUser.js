var dashboardUser = angular.module('dashboard.user', [
  'ui.router',
  'exerciseGroups.exerciseGroup',
  'util.promiseUi',
  'measurements.stats',
  'util.filters.withinPeriod'
]);

dashboardUser.controller('DashboardUserCtrl', ['$scope', 'Measurement', '$state', 'toaster', 'ExerciseGroup', '$q', 'MeasurementStats', 'userDashboardOptions', function ($scope, Measurement, $state, toaster, ExerciseGroup, promise, MeasurementStats, myUserDashboardOptions) {
  $scope.userDashboardOptions = myUserDashboardOptions;

  $scope.rightMenu = {items: []};

  var userIdPromise = $scope.userDashboardOptions.userIdPromise;

  $scope.statsPromise = promise
    .all({measurements: fetchMeasurements(userIdPromise), exerciseGroups: ExerciseGroup.query().$promise})
    .catch(overviewCalculationFailed)
    .then(function (fetchedData) {
      $scope.stats = MeasurementStats.calculateMeasurementListStats(fetchedData.measurements, fetchedData.exerciseGroups);
      return $scope.stats;
    });

  $scope.goToTrainingDetails = function (trainingId) {
    $state.go($scope.userDashboardOptions.statePrefix + ".user.calendar.overview", {trainingId: trainingId});
  };

  function fetchMeasurements(userIdPromise) {
    return userIdPromise.then(function (userId) {
      return Measurement.detailedMeasurementsForUser({userId: userId}).$promise;
    });
  }

  function overviewCalculationFailed() {
    toaster.pop("error", "Error while fetching measurements", "Unable to fetch measurements. An unexpected error occurred.");
  }
}]);