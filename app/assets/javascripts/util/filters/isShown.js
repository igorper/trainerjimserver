var isShownFilter = angular.module('util.filters.isShown', []);

isShownFilter.filter('isShown', function () {
  return function (items) {
    return _.filter(items, function (item) {
      return !item.isShown || item.isShown();
    });
  };
});
