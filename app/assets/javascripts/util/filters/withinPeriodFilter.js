var withinPeriod = angular.module('util.filters.withinPeriod', []);

withinPeriod.filter('withinPeriod', function () {
  function daysInPeriod(periodName) {
    switch (periodName) {
      case 'day':
        return 1;
      case 'week':
        return 7;
      case 'month':
        return 30;
      default:
        return undefined;
    }
  }

  function withinDaysFilter(items, days) {
    var from = new Date();
    from.setDate(from.getDate() - days);
    return _.filter(items, function (item) {
      return new Date(item.date) > from;
    });
  }

  return function (items, periodName) {
    var days = daysInPeriod(periodName);
    return _.isFinite(days) ? withinDaysFilter(items, days) : items;
  };
});