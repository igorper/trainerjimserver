var propsFilter = angular.module('util.filters.propsFilter', []);

propsFilter.filter('propsFilter', function () {
  return function (items, props) {
    return _.filter(items, function (item) {
      return _.any(props, function (text, prop) {
        return item[prop].toString().toLowerCase().indexOf(text.toLowerCase()) !== -1;
      });
    });
  };
});
