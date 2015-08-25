var dashboardOverview = angular.module('dashboard.overview', [
  'trainees',
  'users.userStrip',
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
    $scope.inactivityReports = calculateInactivityReports(allData[0], allData[1]);
  });

  $scope.intensityAlertsLoading = promise.all([trainees, traineeIdToRatingCounts]).then(function (allData) {
    $scope.intensityAlerts = calculateIntensityAlerts(allData[0], allData[1]);
  });

  function calculateRestReports(users, userIdToTotalRest, userIdToPlannedRest) {
    return _(users)
      .map(function (user) {
        var totalRest = _.get(userIdToTotalRest, [user.id, 'rest_time'], 0);
        var plannedRest = _.get(userIdToPlannedRest, [user.id, 'rest_time'], 0);
        return {
          user: user,
          totalRestInSeconds: totalRest,
          plannedRestInSeconds: plannedRest,
          restChangeInSeconds: totalRest - plannedRest
        };
      })
      .value();
  }

  $scope.totalRestLoading = promise.all([trainees, traineeIdToTotalRest, traineeIdToPlannedRest]).then(function (allData) {
    $scope.restReports = calculateRestReports(allData[0], allData[1], allData[2]);
  });

  function calculateInactivityReports(users, userIdToMeasurements) {
    var weekAgo = new Date();
    weekAgo.setDate(weekAgo.getDate() - 7);
    return _(users)
      .filter(function (user) {
        return noMeasurementSince(userIdToMeasurements[user.id], weekAgo);
      })
      .map(function (user) {
        var lastActiveDate = getLastActiveDate(user, userIdToMeasurements);
        return {
          user: user,
          lastActiveDate: lastActiveDate,
          inactiveSinceMessage: inactiveSinceMessage(lastActiveDate)
        };
      })
      .value();
  }

  function getLastActiveDate(user, userIdToMeasurements) {
    return _(userIdToMeasurements[user.id])
      .map(function (measurement) {
        return new Date(measurement.start_time);
      })
      .max();
  }

  function inactiveSinceMessage(lastActiveDate) {
    if (_.isDate(lastActiveDate)) {
      var dayInMillis = 24 * 60 * 60 * 1000;
      var days = Math.round(Math.abs((new Date().getTime() - lastActiveDate.getTime()) / dayInMillis));
      return "Inactive for " + days + " days";
    } else {
      return "Inactive for 31 days or more"
    }
  }

  function noMeasurementSince(measurements, since) {
    return _.every(measurements, function (measurement) {
      return new Date(measurement.start_time) < since;
    });
  }

  function calculateIntensityAlerts(users, userIdToRatingCounts) {
    return _(users)
      .filter(function (user) {
        return _.has(userIdToRatingCounts, user.id);
      })
      .map(function (user) {
        var ratingCounts = userIdToRatingCounts[user.id];
        return {
          user: user,
          totalIntensityAlerts: ratingCounts.too_easy_count + ratingCounts.too_hard_count,
          ratingCounts: ratingCounts
        };
      })
      .value();
  }
}]);
