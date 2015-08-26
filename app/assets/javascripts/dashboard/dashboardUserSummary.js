var dashboardUserSummary = angular.module('dashboard.user.summary', [
  'ui.router',
  'nvd3'
]);

dashboardUserSummary.controller('DashboardUserSummaryCtrl', ['$scope', '$state', function ($scope, $state) {
  $scope.sortType = "date";
  $scope.sortReverse = false;
  $scope.periodName = $state.params.filter;

  $scope.populateRightMenu([
    {
      name: "All",
      link: "main.dashboard.user.summary({filter: 'all'})"
    },
    {
      name: "Last month",
      link: "main.dashboard.user.summary({filter: 'month'})"
    },
    {
      name: "Last week",
      link: "main.dashboard.user.summary({filter: 'week'})"
    },
    {
      name: "Last 24 hours",
      link: "main.dashboard.user.summary({filter: 'day'})"
    }
  ], true);

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

}]);