var propsFilter = angular.module('util.filters.propsFilter', []);

propsFilter.filter('propsFilter', function () {
  return function (items, props) {
    return _.filter(items, function (item) {
      return _.any(props, function (text, prop) {
        if (!text) {
          return true;
        }
        var fieldValue = item[prop];
        return fieldValue && fieldValue.toString().toLowerCase().indexOf(text.toLowerCase()) !== -1;
      });
    });
  };
});
