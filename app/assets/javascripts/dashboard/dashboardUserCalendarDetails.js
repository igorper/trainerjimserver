var dashboardUserCalendarDetails = angular.module('dashboard.user.calendar.details', [
  'ui.router'
]);

dashboardUserCalendarDetails.controller('DashboardUserCalendarDetailsCtrl', ['$scope', '$state', function ($scope, $state) {

  $scope.isDurationExercise = function (exercise) {
    return exercise.guidance_type === 'duration';
  };

}]);

dashboardUserCalendarDetails.directive('horizontalBar', [function () {

  // constants
  var width = 100;

  return {
    restrict: 'E',
    scope: {
      rest: '=',
      expected: '=',
      actual: '=',
      label: '='
    },
    link: function (scope, element, attrs) {
      // set up initial svg object
      var chart = d3.select(element[0])
        .append("svg")
        .attr("class", "chart")
        .attr("width", width)
        .attr("height", 30);

      var ex, ac, rest, label;

      function refreshBar() {
        if (ex === undefined || ac === undefined || rest === undefined) {
          return;
        }

        var scale = d3.scale.linear()
          .domain([0, d3.max([ex, ac])])
          .range([0, width]);

        // draw the blue box representing the expected quantity
        chart.append("svg:rect")
          .attr("class", "blue")
          .attr("width", scale(ex))
          .attr("height", 30);

        // draw the box visualizing the deviation from the expected quantity
        chart.append("svg:rect")
          .attr("class", rest ? (ac < ex ? "green" : "red") : (ac < ex ? "red" : "green"))
          .attr("x", scale(ac < ex ? ac : ex))
          .attr("y", 1)
          .attr("width", scale(ac < ex ? ex : ac))
          .attr("height", 28);

        // draw the vertical line that visualizes the expected quantity
        var xLine = scale(ex) == 0 ? scale(ex) + 2 : (scale(ex) == width ? scale(ex) - 2 : scale(ex));
        chart.append("line")
          .attr("x1", xLine)
          .attr("y1", 0)
          .attr("x2", xLine)
          .attr("y2", 30)
          .attr("stroke-width", 4)
          .attr("stroke", "black");

        chart.append("text")
          .attr("x", 20)
          .attr("y", 21)
          .text(label)
          .attr("font-size", "20px")
          .attr("font-weigth", "bold")
          .attr("fill", "white");

        // write the text with the actual and expected quantity
      }

      scope.$watch('expected', function (newVal, oldVal) {

        if (newVal === undefined) {
          return;
        }

        ex = newVal;

        refreshBar();
      });

      scope.$watch('actual', function (newVal, oldVal) {

        if (newVal === undefined) {
          return;
        }

        ac = newVal;

        refreshBar();
      });

      scope.$watch('rest', function (newVal, oldVal) {

        if (newVal === undefined) {
          return;
        }

        rest = newVal;

        refreshBar();
      });

      scope.$watch('label', function (newVal, oldVal) {

        if (newVal === undefined) {
          return;
        }

        label = newVal;

        refreshBar();
      });

    }
  }
}]);