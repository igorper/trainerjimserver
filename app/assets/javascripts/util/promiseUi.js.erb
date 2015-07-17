var promiseUi = angular.module('util.promiseUi', []);

promiseUi.factory('getPromise', function () {
  return function (value) {
    if (value) {
      if (value.$promise && value.$promise.then) {
        return value.$promise;
      } else if (value.then) {
        return value;
      }
    }
    return null;
  };
});

promiseUi.directive('spinUntil', ['$window', 'getPromise', function ($window, getPromise) {
  return {
    scope: {spinUntil: '='},
    transclude: true,
    template: '<div ng-transclude></div>',
    link: function (scope, element) {
      var spinner = new $window.Spinner();
      var spinnerElement = element.children()[0];

      function stopSpinning() {
        spinner.stop(spinnerElement);
      }

      stopSpinning();

      scope.$watch('spinUntil', function (value) {
          var promise = getPromise(value);
          if (promise) {
            spinner.spin(spinnerElement);
            promise.then(stopSpinning, stopSpinning);
          }
        }
      );
    }
  };
}]);

promiseUi.directive('disableUntil', ['getPromise', function (getPromise) {
  return {
    transclude: true,
    scope: {disableUntil: '='},
    template: '<div ng-transclude></div>',
    link: function (scope, element) {
      function onPromiseStarted() {
        element.attr('disabled', 'true');
      }

      function onPromiseCompleted() {
        element.removeAttr('disabled');
      }

      onPromiseCompleted();

      scope.$watch('disableUntil', function (value) {
          var promise = getPromise(value);
          if (promise) {
            onPromiseStarted();
            promise.then(onPromiseCompleted, onPromiseCompleted);
          }
        }
      );
    }
  };
}]);
