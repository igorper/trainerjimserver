var dashboardUserSummary = angular.module('dashboard.user.summary', [
  'ui.router',
  'nvd3'
]);

dashboardUserSummary.controller('DashboardUserSummaryCtrl', ['$scope', '$state', function ($scope, $state) {
  $scope.sortType = "date";
  $scope.sortReverse = true;
  $scope.periodName = $state.params.filter;

  $scope.rightMenu.items = [
    {
      name: "All",
      link: getSummaryLink('all')
    },
    {
      name: "Last month",
      link: getSummaryLink('month')
    },
    {
      name: "Last week",
      link: getSummaryLink('week')
    },
    {
      name: "Last 24 hours",
      link: getSummaryLink('day')
    }
  ];

  function getSummaryLink(filter) {
    return $scope.userDashboardOptions.summaryState + "({filter: '" + filter + "'})"
  }

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