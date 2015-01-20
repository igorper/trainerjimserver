//= require angular/angular
//= require angular-ui-select/dist/select
//= require exerciseTypes/exerciseType
//= require angularjs-toaster/toaster

var exerciseTypesSelector = angular.module('exerciseTypes.selector', [
  'ui.select',
  'exerciseTypes',
  'toaster'
]);

exerciseTypesSelector.factory('ExerciseTypesSelector', ['$modal', function ($modal) {
  return function () {
    return $modal.open({
      templateUrl: 'exerciseTypes/selector/exercise-type-selector.html',
      controller: 'SelectExerciseTypeCtrl',
      backdrop: 'static',
      windowClass: 'modal-window'
    });
  };
}]);

exerciseTypesSelector.controller("SelectExerciseTypeCtrl", ["$scope", '$modalInstance', 'ExerciseType', 'toaster',
  function ($scope, $modalInstance, ExerciseType, toaster) {
    $scope.exerciseType = {};
    $scope.exerciseTypes = [];

    $scope.ok = function () {
      if ($scope.exerciseType.selected == undefined) {
        toaster.pop("warning", "Please select an exercise.");
      } else {
        $modalInstance.close($scope.exerciseType.selected);
      }
    };

    $scope.cancel = function () {
      $modalInstance.dismiss();
    };

    ExerciseType.query(function (data) {
      $scope.exerciseTypes = data;
    }, function (data, status, headers) {
      toaster.pop("error", "Could not fetch the list of exercises. Try logging in.");
    });
  }
]);

exerciseTypesSelector.filter('propsFilter', function () {
  return function (items, props) {
    var out = [];

    if (angular.isArray(items)) {
      items.forEach(function (item) {
        var itemMatches = false;

        var keys = Object.keys(props);
        for (var i = 0; i < keys.length; i++) {
          var prop = keys[i];
          var text = props[prop].toLowerCase();
          if (item[prop].toString().toLowerCase().indexOf(text) !== -1) {
            itemMatches = true;
            break;
          }
        }

        if (itemMatches) {
          out.push(item);
        }
      });
    } else {
      // Let the output be the input untouched
      out = items;
    }

    return out;
  }
});
