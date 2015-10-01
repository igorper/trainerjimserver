describe("Measurements Stats", function () {
  beforeEach(module('measurements.stats'));
  beforeEach(inject(['MeasurementStats', function (MeasurementStats) {
    this.MeasurementStats = MeasurementStats;
  }]));

  it("determines that there are no skipped series", function () {
    var measurements = {
      "training": {"exercises": [{"series": [{"id": 1}, {"id": 2}], "exercise_type": {}}]},
      "series_executions": [{"series_id": 1}, {"series_id": 2}]
    };
    var stats = this.MeasurementStats.calculateMeasurementStats(measurements);
    expect(stats.seriesSkipped).toEqual(0);
  });

  it("calculates skipped series when series executions are duplicated", function () {
    var measurements = {
      "training": {"exercises": [{"series": [{"id": 1}, {"id": 2}], "exercise_type": {}}]},
      "series_executions": [{"series_id": 1}, {"series_id": 1}]
    };
    var stats = this.MeasurementStats.calculateMeasurementStats(measurements);
    expect(stats.seriesSkipped).toEqual(1);
  });
});