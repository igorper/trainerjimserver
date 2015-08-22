var dashboardOverview = angular.module('dashboard.overview', [
  'trainees',
  'util.promiseUi',
  'util.collections',
  'dashboard'
]);

dashboardOverview.controller('DashboardOverviewCtrl', ['$scope', 'Trainee', '$q', 'Dashboard', function ($scope, Trainee, promise, Dashboard) {
  var trainees = Trainee.query().$promise;
  var traineeIdToMeasurements = Dashboard.monthlyOverview().$promise.then(_.partial(toLookupManyByField, _, 'trainee_id'));
  var traineeIdToRatingCounts = Dashboard.ratingCounts().$promise.then(_.partial(toLookupByField, _, 'user_id'));
  var traineeIdToTotalRest = Dashboard.totalRest().$promise.then(_.partial(toLookupByField, _, 'user_id'));
  var traineeIdToPlannedRest = Dashboard.plannedRest().$promise.then(_.partial(toLookupByField, _, 'user_id'));

  $scope.inactiveUsersLoading = promise.all([trainees, traineeIdToMeasurements]).then(function (allData) {
    $scope.inactiveUsers = calculateInactiveUsers(allData[0], allData[1]);
  });

  $scope.intensityAlertsLoading = promise.all([trainees, traineeIdToRatingCounts]).then(function (allData) {
    $scope.intensityAlerts = allData[1];
  });

  $scope.totalRestLoading = promise.all([trainees, traineeIdToTotalRest, traineeIdToPlannedRest]).then(function (allData) {
    $scope.totalRests = allData[1];
    $scope.plannedRests = allData[2];
  });

  function calculateInactiveUsers(trainees, traineeIdToMeasurements) {
    var weekAgo = new Date();
    weekAgo.setDate(weekAgo.getDate() - 7);
    return _(trainees).filter(function (trainee) {
      return inactiveSince(trainee, weekAgo, traineeIdToMeasurements);
    });
  }

  function inactiveSince(trainee, since, traineeIdToMeasurements) {
    return _.every(traineeIdToMeasurements[trainee.id], function (measurement) {
      return new Date(measurement.start_time) < since;
    });
  }

}]);