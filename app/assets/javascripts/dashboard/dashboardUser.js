var dashboardUser = angular.module('dashboard.user', [
  'ui.router',
  'exerciseGroups.exerciseGroup',
  'util.promiseUi',
  'measurements.stats',
  'util.filters.withinPeriod'
]);

dashboardUser.controller('DashboardUserCtrl', ['$scope', 'Measurement', '$state', 'toaster', 'ExerciseGroup', '$q', 'MeasurementStats', function ($scope, Measurement, $state, toaster, ExerciseGroup, promise, MeasurementStats) {
    $scope.rightMenu = {
      items: [],
      visible: false
    };

    $scope.populateRightMenu = function (menuItems, visible) {
      // clear the array and push navigation for this page
      // it's important that we do not create a new array here otherwise
      // the binding between the template and the array will be lost
      $scope.rightMenu.items.length = 0;

      for(var i=0; i < menuItems.length; i++){
        $scope.rightMenu.items.push(menuItems[i]);
      }

      $scope.rightMenu.visible = visible;
    }

    $scope.statsPromise = promise
      .all({measurements: fetchMeasurements(), exerciseGroups: ExerciseGroup.query().$promise})
      .catch(overviewCalculationFailed)
      .then(function (fetchedData) {
        $scope.stats = MeasurementStats.calculateMeasurementListStats(fetchedData.measurements, fetchedData.exerciseGroups);
        return $scope.stats;
      });

    function fetchMeasurements() {
      return Measurement.detailedMeasurementsForUser($state.params).$promise;
    }

    function overviewCalculationFailed() {
      toaster.pop("error", "Error while fetching measurements", "Unable to fetch measurements. An unexpected error occurred.");
    }
  }]
);