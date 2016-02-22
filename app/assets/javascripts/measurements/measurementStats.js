var measurementsStats = angular.module('measurements.stats', [
  'measurements',
  'util.collections'
]);

measurementsStats.factory('MeasurementStats', ['Measurement', function (Measurement) {
  var measurementStatsApi = {};

  measurementStatsApi.calculateMeasurementListStats = function (measurements, exerciseGroups) {
    var stats = {};

    // the input can also be an empty promise object that breaks the calculations
    if(angular.isArray(measurements)){
      stats.executedExerciseGroupsCounts = countExecutedExerciseGroups(measurements);
      stats.exerciseGroupsLookup = toLookupById(exerciseGroups);
      stats.partitionedGroupCounts = partitionExerciseGroupCounts(stats.exerciseGroupsLookup, stats.executedExerciseGroupsCounts);
      stats.muscleGroupCounts = stats.partitionedGroupCounts[0];
      stats.equipmentGroupCounts = stats.partitionedGroupCounts[1];
      stats.measurementsStats = _.map(measurements, measurementStatsApi.calculateMeasurementStats);
    }

    return stats;
  };

  measurementStatsApi.calculateMeasurementStats = function (measurement) {
    var stats = {};

    if(measurement.training !== undefined){
      stats.measurement = measurement;
      stats.training = extractTrainingWithSeriesExecutions(measurement);
      stats.seriesLookup = toLookupById(_(stats.training.exercises).pluck('series').flatten().value());
      stats.exerciseLookup = createExerciseLookup(stats.training.exercises);
      stats.name = stats.training.name;
      stats.date = measurement.start_time;
      stats.comment = measurement.comment;
      stats.totalSeries = countSeriesInTraining(stats.training);
      stats.performedSeries = _(measurement.series_executions).pluck('series_id').uniq().size();
      stats.seriesSkipped = stats.totalSeries - stats.performedSeries;
      stats.restTimeChangeInSeconds = restTimeChangeInSeconds(measurement.series_executions, stats.seriesLookup);
      stats.seriesTooHardCount = _(measurement.series_executions).where({rating: Measurement.TOO_HARD_RATING}).size();
      stats.seriesTooEasyCount = _(measurement.series_executions).where({rating: Measurement.TOO_EASY_RATING}).size();
      stats.seriesOkayCount = _(measurement.series_executions).where({rating: Measurement.OKAY_RATING}).size();
      stats.seriesNotOkayCount = stats.performedSeries - stats.seriesOkayCount;
      stats.durationInMinutes = (new Date(measurement.end_time) - new Date(measurement.start_time)) / (1000 * 60);
      stats.totalRestInMinutes = totalRestInSeconds(measurement.series_executions) / 60.0;
      stats.totalExercisesInMinutes = stats.durationInMinutes - stats.totalRestInMinutes;
      stats.totalExercises = countExercisesInTraining(stats.training);
      stats.performedExercises = countPerformedExercises(measurement.series_executions, stats.exerciseLookup);
      stats.weightChange = calculateWeightChange(measurement.series_executions, stats.seriesLookup);
      stats.weightChangeNumber = calculateWeightChangeNumber(measurement.series_executions, stats.seriesLookup);
      stats.repChange = calculateRepChange(measurement.series_executions, stats.seriesLookup);
      stats.repChangeNumber = calculateRepChangeNumber(measurement.series_executions, stats.seriesLookup);

    }

    return stats;
  };

  function createExerciseLookup(exercises){
    return _.reduce(exercises, function(lookup, ex) {
      _.each(ex.series, function(s) {
        return lookup[s.id] = ex;
      });
      return lookup;
    }, {})
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

  function totalRestInSeconds(seriesExecutions){
    return _.reduce(seriesExecutions, function(total, se){
      return total + se.rest_time;
    }, 0);
  }

  function countPerformedExercises(seriesExecutions, seriesLookup){
    return _.unique(_.map(seriesExecutions, function(se) {
      return seriesLookup[se.series_id].exercise_type.id;
    })).length;
  }

  function countExercisesInTraining(training){
    return _.unique(_.map(training.exercises, function(ex) {
      return ex.exercise_type.id;
    })).length;
  }

  function calculateWeightChange(seriesExecutions, seriesLookup) {
    return _.reduce(seriesExecutions, function (change, se) {
      return change + se.weight - seriesLookup[se.series_id].weight;
    }, 0);
  }

  function calculateWeightChangeNumber(seriesExecutions, seriesLookup) {
    return _.reduce(seriesExecutions, function (change, se) {
      return change + (se.weight === seriesLookup[se.series_id].weight ? 0 : 1);
    }, 0);
  }

  function calculateRepChange(seriesExecutions, seriesLookup) {
    return _.reduce(seriesExecutions, function (change, se) {
      return change + se.num_repetitions - seriesLookup[se.series_id].repeat_count;
    }, 0);
  }

  function calculateRepChangeNumber(seriesExecutions, seriesLookup) {
    return _.reduce(seriesExecutions, function (change, se) {
      return change + (se.num_repetitions === seriesLookup[se.series_id].repeat_count ? 0 : 1);
    }, 0);
  }

  function extractTrainingWithSeriesExecutions(measurement){
    // for all exercises
    _.each(
      // extract their series
      _.flatten(
        _.pluck(measurement.training.exercises, 'series')), function(s) {
        // and add them a field execution pointing to the series_execution object
        // (if exist - otherwise it's set to undefined)
        s.execution = _.find(measurement.series_executions, function(se) {
          return se.series_id == s.id;
        })
      });

    return measurement.training;
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
    return _(exerciseGroupCounters)
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