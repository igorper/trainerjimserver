describe("Measurements Stats", function () {
  var MeasurementStats;
  beforeEach(module('measurements.stats'));
  beforeEach(inject(['MeasurementStats', function (_MeasurementStats) {
    MeasurementStats = _MeasurementStats;
  }]));

  it("determines that there are no skipped series", function () {
    var measurements = {
      "training": {"exercises": [{"series": [{"id": 1}, {"id": 2}], "exercise_type": {}}]},
      "series_executions": [{"series_id": 1}, {"series_id": 2}]
    };
    var stats = MeasurementStats.calculateMeasurementStats(measurements);
    expect(stats.seriesSkipped).toBe(0);
  });

  it("calculates skipped series when series executions are duplicated", function () {
    var measurements = {
      "training": {"exercises": [{"series": [{"id": 1}, {"id": 2}], "exercise_type": {}}]},
      "series_executions": [{"series_id": 1}, {"series_id": 1}]
    };
    var stats = MeasurementStats.calculateMeasurementStats(measurements);
    expect(stats.seriesSkipped).toBe(1);
  });
});