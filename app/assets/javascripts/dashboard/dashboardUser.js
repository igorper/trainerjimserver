var dashboardUser = angular.module('dashboard.user', [
  'ui.router',
  'exerciseGroups.exerciseGroup',
  'util.promiseUi',
  'measurements.stats',
  'util.filters.withinPeriod'
]);

function DashboardUserCtrl(userDashboardOptions) {
  return ['$scope', 'Measurement', '$state', 'toaster', 'ExerciseGroup', '$q', 'MeasurementStats', '$injector', function ($scope, Measurement, $state, toaster, ExerciseGroup, promise, MeasurementStats, $injector) {

    $scope.userDashboardOptions = _.extend({
      userIdPromise: [function () {
        return promise(function (resolve) {
          resolve($state.params.userId);
        });
      }],
      calendarState: 'main.dashboard.user.calendar',
      calendarOverviewState: 'main.dashboard.user.calendar.overview',
      calendarDetailsState: 'main.dashboard.user.calendar.details',
      summaryState: 'main.dashboard.user.summary'
    }, userDashboardOptions);

    $scope.rightMenu = {items: []};

    var userIdPromise = $injector.invoke($scope.userDashboardOptions.userIdPromise);

    $scope.statsPromise = promise
      .all({measurements: fetchMeasurements(userIdPromise), exerciseGroups: ExerciseGroup.query().$promise})
      .catch(overviewCalculationFailed)
      .then(function (fetchedData) {
        $scope.stats = MeasurementStats.calculateMeasurementListStats(fetchedData.measurements, fetchedData.exerciseGroups);
        return $scope.stats;
      });

    $scope.goToTrainingDetails = function (trainingId) {
      $state.go($scope.userDashboardOptions.calendarOverviewState, {trainingId: trainingId});
    };

    function fetchMeasurements(userIdPromise) {
      return userIdPromise.then(function (userId) {
        return Measurement.detailedMeasurementsForUser({userId: userId}).$promise;
      });
    }

    function overviewCalculationFailed() {
      toaster.pop("error", "Error while fetching measurements", "Unable to fetch measurements. An unexpected error occurred.");
    }
  }];
}