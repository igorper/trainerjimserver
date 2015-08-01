var measurement = angular.module("measurements", ["ngResource"]);

measurement.factory('Measurement', ["$resource", function ($resource) {
  return $resource("/api/v1/measurements/:id.json",
    {id: '@id'},
    {
      query: {
        method: 'GET',
        isArray: true,
        params: {userId: '@user_id'},
        url: '/api/v1/users/:userId/measurements/.json'
      },
      all: {
        method: 'GET',
        isArray: true,
        url: '/api/v1/measurements.json'
      }
    }
  );
}]);