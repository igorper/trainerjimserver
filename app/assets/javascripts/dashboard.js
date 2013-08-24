$(function () {
  var graphHeight = 400; // also set for scss: .statistics[height]
  var sessionWidth = 60;
  var sessionRightMargin = 20;
  var sessionWidthWithMargin = sessionWidth + sessionRightMargin;

  var data = [
    {
      name: "Leg Press",
      intervals: [
        {type: "workout", percentage: 30, seconds: 80},
        {type: "rest", seconds: 25},
        {type: "workout", percentage: 40, seconds: 100},
        {type: "rest", seconds: 35},
        {type: "workout", percentage: 30, seconds: 90}
      ]
    },
    {
      name: "Bench Press Full",
      intervals: [
        {type: "workout", percentage: 20, seconds: 25},
        {type: "rest", seconds: 40},
        {type: "workout", percentage: 10, seconds: 15}
      ]
    }
  ];

  function getSessionPercentage(session) {
    var totalPercentage = 0;
    $.map(session.intervals, function(interval) {
      if (interval.type === "workout")
        totalPercentage += interval.percentage;
    });
    return totalPercentage;
  }

  function getSessionSeconds(session) {
    var totalSeconds = 0;
    $.map(session.intervals, function(interval) {
      totalSeconds += interval.seconds;
    });
    return totalSeconds;
  }

  function getSessionHeight(session) {
    return (session.totalPercentage / 100.0) * graphHeight;
  }

  function getIntervalHeight(session, interval) {
    return 1.0 * interval.seconds / session.totalSeconds * session.height;
  }

  $.each(data, function(i, session) {
    session.totalPercentage = getSessionPercentage(session);
    session.totalSeconds = getSessionSeconds(session);
    session.height = getSessionHeight(session);
    session.transform = "translate(" + sessionWidthWithMargin * i + ")";
    var y = graphHeight;
    $.each(session.intervals, function(j, interval) {
      interval.height = getIntervalHeight(session, interval);
      y -= interval.height;
      interval.y = y;
      interval.color = interval.type === "workout" ? "steelblue" : "#fbc912";
    });
  });

  function getAttr(attr) {return function(obj) {return obj[attr];};}

  function getTooltipText(interval) {
    var text = "Type: " + interval.type + "\n";
    if (interval.percentage)
      text += "Percentage: " + interval.percentage + "\n";
    text += "Time: " + interval.seconds + "s";
    return text;
  }

  function getSessionCaption(session) {
    return session.totalPercentage + "%";
  }

  var chart = d3.select("div[class='statistics']").append("svg")
    .attr("class", "chart")
    .attr("width", "100%")
    .attr("height", "100%");
  var sessions = chart.selectAll("g").data(data).enter().append("g");
  sessions.attr("transform", getAttr("transform"));
  var intervals = sessions.selectAll("g").data(getAttr("intervals"))
    .enter().append("g");
  intervals.append("title").text(getTooltipText);
  intervals.append("rect")
    .attr("y", getAttr("y"))
    .attr("width", sessionWidth)
    .attr("height", getAttr("height"))
    .attr("fill", getAttr("color"));
  sessions.append("text")
    .attr("x", sessionWidth / 2)
    .attr("y", graphHeight - 5)
    .attr("font-size", 20)
    .attr("fill", "white")
    .attr("style", "writing-mode: tb; text-anchor: end")
    .text(getSessionCaption);
  sessions.append("text")
    .attr("x", sessionWidth / 2)
    .attr("y", graphHeight + 100)
    .attr("font-size", 20)
    .attr("fill", "#555")
    .attr("style", "writing-mode: tb; text-anchor: middle")
    .text(getAttr("name"));
});