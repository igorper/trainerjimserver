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

  it("calculates measurement stats where there are no measurements", function(){
    var measurements = {}

    var stats = this.MeasurementStats.calculateMeasurementStats(measurements);

    expect(stats).toEqual({});
  });

  it("calculates measurement list stats where there are no measurements", function(){
    var measurements = {}

    var stats = this.MeasurementStats.calculateMeasurementListStats(measurements);

    expect(stats).toEqual({});
  });


});