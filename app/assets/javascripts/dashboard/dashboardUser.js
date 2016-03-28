var dashboardUser = angular.module('dashboard.user', [
  'ui.router',
  'exerciseGroups.exerciseGroup',
  'util.promiseUi',
  'measurements.stats',
  'util.filters.withinPeriod'
]);

dashboardUser.controller('DashboardUserCtrl', ['$scope', 'Measurement', '$state', 'toaster', 'ExerciseGroup', '$q', 'MeasurementStats', 'userDashboardOptions',
  '$translate', '$rootScope', function ($scope, Measurement, $state, toaster, ExerciseGroup, promise, MeasurementStats,
                                        myUserDashboardOptions, $translate, $rootScope) {
  function applyTranslations(){
    $translate(['DASHBOARD_USER_CTRL_ERR_FETCH_MEASUREMENTS_TITLE',
      'DASHBOARD_USER_CTRL_ERR_FETCH_MEASUREMENTS_CONTENT',
    ]).then(function(translations){
      $scope.errFetchMeasurementsTitle = translations.DASHBOARD_USER_CTRL_ERR_FETCH_MEASUREMENTS_TITLE;
      $scope.errFetchMeasurementsContent = translations.DASHBOARD_USER_CTRL_ERR_FETCH_MEASUREMENTS_CONTENT;
    });
  }

  applyTranslations();

  $rootScope.$on('$translateChangeSuccess', function () {
    applyTranslations();
  });

  $scope.userDashboardOptions = myUserDashboardOptions;

  $scope.rightMenu = {items: []};
  $scope.measurementsAndExerciseGroups = null;

  var userIdPromise = $scope.userDashboardOptions.userIdPromise;

  $scope.statsPromise = promise
    .all({measurements: fetchMeasurements(userIdPromise), exerciseGroups: ExerciseGroup.query().$promise})
    .catch(overviewCalculationFailed)
    .then(function (fetchedData) {
        $scope.measurementsAndExerciseGroups = fetchedData;
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
    toaster.pop("error", $scope.errFetchMeasurementsTitle, $scope.errFetchMeasurementsContent);
  }
}]);