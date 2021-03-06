var dashboardOverview = angular.module('dashboard.overview', [
  'trainees',
  'users.userStrip',
  'util.promiseUi',
  'util.collections',
  'dashboard',
  'translations',
]);

dashboardOverview.controller('DashboardOverviewCtrl', ['$scope', 'Trainee', '$q', 'Dashboard', '$translate', '$rootScope',
  function ($scope, Trainee, promise, Dashboard, $translate, $rootScope) {
  function applyTranslations(){
    $translate(['DASHBOARD_OVERVIEW_INACTIVITY_BEFORE_TEXT',
      'DASHBOARD_OVERVIEW_INACTIVITY_AFTER_TEXT',
      'DASHBOARD_OVERVIEW_INACTIVITY_LONGER_TEXT'
    ]).then(function(translations){
      $scope.inactivityBeforeText = translations.DASHBOARD_OVERVIEW_INACTIVITY_BEFORE_TEXT;
      $scope.inactivityAfterText = translations.DASHBOARD_OVERVIEW_INACTIVITY_AFTER_TEXT;
      $scope.inactivityLongerText = translations.DASHBOARD_OVERVIEW_INACTIVITY_LONGER_TEXT;
    });
  }

  applyTranslations();

  $rootScope.$on('$translateChangeSuccess', function () {
    applyTranslations();
  });

  var trainees = Trainee.query().$promise;
  var traineeIdToMeasurements = Dashboard.monthlyOverview().$promise.then(_.partial(toLookupManyByField, _, 'trainee_id'));
  var traineeIdToRatingCounts = Dashboard.ratingCounts().$promise.then(_.partial(toLookupByField, _, 'user_id'));
  var traineeIdToTotalRest = Dashboard.totalRest().$promise.then(_.partial(toLookupByField, _, 'user_id'));
  var traineeIdToPlannedRest = Dashboard.plannedRest().$promise.then(_.partial(toLookupByField, _, 'user_id'));

  $scope.inactiveUsersLoading = promise.all([trainees, traineeIdToMeasurements]).then(_.spread(calculateInactivityReports));
  $scope.intensityAlertsLoading = promise.all([trainees, traineeIdToRatingCounts]).then(_.spread(calculateIntensityAlerts));
  $scope.totalRestLoading = promise.all([trainees, traineeIdToTotalRest, traineeIdToPlannedRest]).then(_.spread(calculateRestReports));

  function calculateInactivityReports(users, userIdToMeasurements) {
    var weekAgo = new Date();
    weekAgo.setDate(weekAgo.getDate() - 7);
    $scope.inactivityReports = _(users)
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

  function calculateIntensityAlerts(users, userIdToRatingCounts) {
    $scope.intensityAlerts = _(users)
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

  function calculateRestReports(users, userIdToTotalRest, userIdToPlannedRest) {
    $scope.restReports = _.map(users, function (user) {
      var totalRest = _.get(userIdToTotalRest, [user.id, 'rest_time'], 0);
      var plannedRest = _.get(userIdToPlannedRest, [user.id, 'rest_time'], 0);
      return {
        user: user,
        totalRestInSeconds: totalRest,
        plannedRestInSeconds: plannedRest,
        restChangeInSeconds: totalRest - plannedRest
      };
    });
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
      return $scope.inactivityBeforeText + days + $scope.inactivityAfterText;
    } else {
      return $scope.inactivityLongerText;
    }
  }

  function noMeasurementSince(measurements, since) {
    return _.every(measurements, function (measurement) {
      return new Date(measurement.start_time) < since;
    });
  }
}]);
