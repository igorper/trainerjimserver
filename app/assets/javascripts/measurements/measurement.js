var measurement = angular.module('measurements', ['ngResource']);

measurement.factory('Measurement', ['$resource', function ($resource) {
  var Measurement = $resource('/api/v1/measurements/:id.json',
    {id: '@id'},
    {
      queryForUser: {
        method: 'GET',
        isArray: true,
        params: {userId: '@user_id'},
        url: '/api/v1/users/:userId/measurements/.json'
      },
      detailedMeasurementsForUser: {
        method: 'GET',
        isArray: true,
        params: {userId: '@user_id'},
        url: '/api/v1/users/:userId/detailed_measurements.json'
      },
      detailedMeasurements: {
        method: 'GET',
        isArray: true,
        params: {},
        url: '/api/v1/measurements/detailed_measurements.json'
      },
      monthlyOverview: {method: 'GET', isArray: true, params: {}, url: '/api/v1/measurements/monthly_overview.json'}
    }
  );

  Measurement.TOO_HARD_RATING = 0;
  Measurement.OKAY_RATING = 1;
  Measurement.TOO_EASY_RATING = 2;

  return Measurement;
}]);