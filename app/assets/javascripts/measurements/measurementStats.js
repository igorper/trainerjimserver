var measurementsStats = angular.module('measurements.stats', [
  'measurements'
]);

measurementsStats.factory('MeasurementStats', ['Measurement', function (Measurement) {
  var measurementStatsApi = {};

  measurementStatsApi.calculateMeasurementListStats = function (measurements, exerciseGroups) {
    var stats = {};

    stats.executedExerciseGroupsCounts = countExecutedExerciseGroups(measurements);
    stats.exerciseGroupsLookup = toLookupById(exerciseGroups);
    stats.partitionedGroupCounts = partitionExerciseGroupCounts(stats.exerciseGroupsLookup, stats.executedExerciseGroupsCounts);
    stats.muscleGroupCounts = stats.partitionedGroupCounts[0];
    stats.equipmentGroupCounts = stats.partitionedGroupCounts[1];
    stats.measurementsStats = _.map(measurements, measurementStatsApi.calculateMeasurementStats);

    return stats;
  };

  measurementStatsApi.calculateMeasurementStats = function (measurement) {
    var stats = {};

    stats.measurement = measurement;
    stats.training = measurement.training;
    stats.seriesLookup = toLookupById(_.chain(stats.training.exercises).pluck('series').flatten().value());
    stats.name = stats.training.name;
    stats.date = measurement.start_time;
    stats.comment = measurement.comment;
    stats.totalSeries = countSeriesInTraining(stats.training);
    stats.performedSeries = measurement.series_executions.length;
    stats.seriesSkipped = stats.totalSeries - stats.performedSeries;
    stats.restTimeChangeInSeconds = restTimeChangeInSeconds(measurement.series_executions, stats.seriesLookup);
    stats.seriesTooHardCount = _.chain(measurement.series_executions).where({rating: Measurement.TOO_HARD_RATING}).size().value();
    stats.seriesTooEasyCount = _.chain(measurement.series_executions).where({rating: Measurement.TOO_EASY_RATING}).size().value();
    stats.seriesOkayCount = _.chain(measurement.series_executions).where({rating: Measurement.OKAY_RATING}).size().value();
    stats.seriesNotOkayCount = stats.performedSeries - stats.seriesOkayCount;

    return stats;
  };

  function toLookupById(itemsWithIds) {
    return _.reduce(itemsWithIds, function (lookupById, item) {
      lookupById[item.id] = item;
      return lookupById;
    }, {});
  }

  function countSeriesInTraining(training) {
    return _.reduce(training.exercises, function (count, exercise) {
      return count + _.size(exercise.series);
    }, 0);
  }

  function restTimeChangeInSeconds(seriesExecutions, seriesLookup) {
    return _.reduce(seriesExecutions, function (change, se) {
      return change + se.rest_time - seriesLookup[se.series_id].rest_time;
    }, 0);
  }

  /**
   * @param measurements the measurement in which to count executed exercise groups.
   * @return a lookup object from exercise groups to the number of times they appeared in executed series
   * in the given measurements.
   */
  function countExecutedExerciseGroups(measurements) {
    var seriesToExerciseGroups = extractSeriesToExerciseGroupIdsLookup(measurements);
    var exerciseGroupCounts = {};
    _.each(measurements, function (measurement) {
      _.each(measurement.series_executions, function (seriesExecution) {
        _.each(seriesToExerciseGroups[seriesExecution.series_id], function (groupId) {
          exerciseGroupCounts[groupId] = 1 + (exerciseGroupCounts[groupId] || 0);
        });
      });
    });
    return exerciseGroupCounts;
  }

  /**
   * @return {*} a lookup object of series IDs to lists of group IDs to which these series belong.
   */
  function extractSeriesToExerciseGroupIdsLookup(measurements) {
    var seriesToExerciseGroups = {};
    _.each(measurements, function (measurement) {
      _.each(measurement.training.exercises, function (exercise) {
        _.each(exercise.series, function (serie) {
          seriesToExerciseGroups[serie.id] = _.union(exercise.exercise_type.exercise_groups, seriesToExerciseGroups[serie.id]);
        });
      });
    });
    return seriesToExerciseGroups;
  }

  function partitionExerciseGroupCounts(exerciseGroupsLookup, exerciseGroupCounters) {
    return _.chain(exerciseGroupCounters)
      .map(function (count, exerciseGroupId) {
        return {exerciseGroup: exerciseGroupsLookup[exerciseGroupId], count: count};
      })
      .partition(function (exerciseGroupAndCount) {
        return exerciseGroupAndCount.exerciseGroup.is_machine_group;
      })
      .value();
  }

  return measurementStatsApi;
}]);