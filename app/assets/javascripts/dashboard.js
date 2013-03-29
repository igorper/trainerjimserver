//= require jquery.flot
//= require jquery.flot.resize
//= require knockout-2.2.1
//= require knockout.mapping

Array.prototype.sum = function() {
    if (this.length > 0) {
        return this.reduce(function(x, y) {
            return x + y;
        })
    }
    return 0;
};

var measurementData = [];
var graphcomments = [];

var debug;



function KilogramsLifted(array) {
    return $.map(array, function(impl) {
        return impl.num_repetitions * impl.weight;
    }).sum();
}
;

function Flatten(array) {
    return $.map(array, function(el) {
        return el.executions;
    });
}

function Duration(array) {
    return $.map(array, function(impl) {
        return impl.duration_seconds;
    }).sum();
}
;

$("document").ready(function() {
    var placeholder = $("#placeholder");
    var graphDrawn = false;

    $.getJSON('/users/list.json', function(data) {


        function StatisticsPanel(exerciseTypes, root) {
            var self = this;
            self.parent = root;
            self.exerciseTypes = exerciseTypes;


            self.exerciseSelected = ko.observable(false);
            self.workoutSelected = ko.computed(function() {
                return !self.exerciseSelected();
            });

            self.toggle = function() {
                return self.exerciseSelected(!self.exerciseSelected());
            };

            self.weightLifted = ko.computed(function() {
                if (self.workoutSelected()) {
                    if (self.exerciseTypes.length > 0) {
                        return KilogramsLifted(Flatten(self.exerciseTypes));
                    }
                } else if (self.parent.selectedExercise() !== null) {

                    return KilogramsLifted(self.parent.selectedExercise().executions);
                }
                return 0;
            });

            self.duration = ko.computed(function() {
                if (self.workoutSelected()) {
                    if (self.exerciseTypes.length > 0) {
                        return Duration(Flatten(self.exerciseTypes));
                    }
                } else if (self.parent.selectedExercise() !== null) {
                    return Duration(self.parent.selectedExercise().executions);
                }
                return 0;
            });
        }

        function CommentsViewModel() {
            var self = this;
            self.comments = ko.observable([]);
            
            self.setup = function(data){
                self.answered(false);
                self.inputText("");
                self.answer("");
                self.comments(data);
            };
            
            self.anyComments = ko.computed(function() {
                return self.comments().length > 0;
            });
            self.last = ko.computed(function() {
                return self.comments()[0];
            });

            ///Not yet implemented so always set to false from the start
            self.answered = ko.observable(false);

            self.replyFormVisible = ko.observable(false);
            self.toggleReply = function() {
                selfC.replyFormVisible(!self.replyFormVisible());
            };

            self.inputText = ko.observable("");
            self.answer = ko.observable();

            self.postReply = function() {
                self.answer(self.inputText());
                self.answered(true);
                $("#view-popup").attr("data-original-title",self.answer());
                $("#view-popup").hover(function() {
                   $(this).tooltip("show");
                });
            };


            self.replyInputOn = ko.observable(false);
            self.replyToggle = function() {
                self.replyInputOn(!self.replyInputOn());
            };
        }

        function CalendarViewModel(parent) {
            ///Calendar
            var self = this;

            self.setup = function(data) {
                if (data.length > 0) {
                    self.calendar(data);
                    self.currentMonthIndex(0);
                    days = self.currentMonth().days;
                    self.measurementSelected(days[days.length - 1]);
                } else {
                    self.calendar([]);
                    self.currentMonthIndex(0);
                    self.selectedDay(null);
                }
            };

            self.parent = parent;
            self.calendar = ko.observable([]);
            self.currentMonthIndex = ko.observable(0);
            self.selectedDay = ko.observable();
            self.calendarVisible = ko.computed(function() {
                return self.calendar() && self.calendar().length > 0;
            });

            self.currentMonth = ko.computed(function() {
                return self.calendarVisible() && self.calendar()[self.currentMonthIndex()];
            });

            self.scrollMonth = function(ammount) {
                i = self.currentMonthIndex();
                i += ammount;
                if (i >= self.calendar().length)
                {
                    i = 0;
                } else if (i < 0) {
                    i = self.calendar().length - 1;
                }
                self.currentMonthIndex(i);

                //Clear graph display
                self.parent.clearGraphs();

                ///Selectet first measurement          
                days = self.currentMonth().days;
                self.measurementSelected(days[days.length - 1]);
            };

            self.measurementSelected = function(el) {
                if (self.selectedDay() !== el) {
                    self.selectedDay(el);
                    $.getJSON("/dashboard/measurement/" + el.measurements[0].id, function(data) {

                        self.parent.exerciseTypes(data.types);
                        self.parent.measurement(data.measurement);

                        graphcomments = data.measurement.measurement_comment;
                        measurementData = eval(data.measurement.data);

                        self.parent.clearGraphs();
                        self.parent.statistics(new StatisticsPanel(data.types, self.parent));

                        ///Select first exercise type
                        self.parent.onExerciseClick(self.parent.exerciseTypes()[0]);
                    });
                }
            };
        }
        ;




        function UsersViewModel() {
            var self = this;
            debug = this;

            self.dateFormat = function(time) {
                return $.datepicker.formatDate('dd, MM ,yy', new Date(time));
            };

            self.clearGraphs = function() {
                self.selectedExercise(null);
                self.exerciseExecutions(null);
                self.selectedExecution(null);
                placeholder.unbind("plotclick");
                placeholder.unbind("plothover");
                $.plot(placeholder, [], options);
            };

            self.userChanged = function() {
                self.statistics(null);
                self.clearGraphs();
            }

            ///Users display
            self.users = ko.mapping.fromJS(data);
            self.selectedUser = ko.observable(null);

            self.commentsVM = new CommentsViewModel();
            self.calendarVM = new CalendarViewModel(self);
            self.statistics = ko.observable(null);

            ///Measurements
            self.measurement = ko.observable();
            self.selectedExercise = ko.observable(null);
            self.exerciseExecutions = ko.observable();
            self.hasExerciseMeasurements = ko.computed(function() {
                return self.selectedExercise() !== null && self.selectedExercise().executions.length > 0 && self.selectedExercise().executions[0].start_timestamp !== null;
            });


            self.selectedExerciseWeightInfo = ko.computed(function() {
                if (self.selectedExercise() !== null) {
                    var ex = self.selectedExercise().executions[0];
                    return ex.num_repetitions + "X<br>" + ex.weight + "kg"
                }
            });


            self.selectedExecution = ko.observable(null);

            ///Draw the grapsh here
            self.measurementsAvailable = ko.computed(function() {
                return self.selectedExecution() !== null && self.selectedExecution().start_timestamp !== null;
            });

            ///Just text info
            self.alternateExerciseInfo = ko.computed(function() {
                return  self.selectedExecution() !== null && self.selectedExecution().start_timestamp === null;
            });

            self.exerciseTypes = ko.observable([]);
            self.typesVisible = ko.computed(function() {
                return self.exerciseTypes() !== null && self.exerciseTypes().length > 0;
            });

            self.onExerciseClick = function(element) {
                self.selectedExercise(element);
                self.exerciseExecutions(element.executions);
                self.onGraphChangeButton(element.executions[0]);
            };
            self.onGraphChangeButton = function(element) {
                self.selectedExecution(element);

                graphcomments = element.measurement_comments;

                placeholder.unbind("plotclick");
                placeholder.unbind("plothover");
                self.drawGraph();
                placeholder.bind("plotclick", onClick);
                placeholder.bind("plothover", onHover);


            };

            self.drawGraph = function() {
                element = self.selectedExecution();
                setUpGraph(placeholder, getGraphData(measurementData, element.start_timestamp, element.end_timestamp));
            };

            self.addComment = function(comment) {
                self.selectedExecution().measurement_comments.push(comment);
                self.drawGraph();
            };

            self.removeComment = function(indx) {
                self.selectedExecution().measurement_comments.splice(indx, 1);
                self.drawGraph();
            };

            self.statisticsVisible = ko.computed(function() {
                return self.selectedUser() !== null;
            });


            self.selectUsers = function(element) {
                if (element !== self.selectedUser()) {
                    self.selectedUser(element);
                    self.clearGraphs();
                    self.exerciseTypes([]);


                    $.getJSON("/conversations/list/" + self.selectedUser().id() + ".json", function(data) {
                        self.commentsVM.setup(data);
                        $.getJSON("/dashboard/exercisedates/" + element.id() + ".json", function(data) {
                            self.calendarVM.setup(data);
                        });
                    });
                    self.userChanged();
                }
            };
        }
        ;
        ko.applyBindings(new UsersViewModel());
    });
});



function getGraphData(measurements, start, stop) {
///Gets the readings and comments for a given interval
    startindex = 1;
    stopindex = measurements.length - 1;
    for (i = 1; i < measurements.length; i += 2) {
        if (measurements[i] < start) {
            startindex = i + 2;
        }
        if (measurements[i] > stop) {
            stopindex = i - 2;
            break;
        }
    }

    slice = measurements.slice(startindex - 1, stopindex + 1);

    //find comments
    commentList = [];
    for (i = 0; i < graphcomments.length; i++) {
        var time = graphcomments[i].timestamp;
        commentList.push(
                [slice[2 * time + 1], slice[2 * time], graphcomments[i].comment, graphcomments[i].id]);
    }


    return [slice, commentList];
}

var plot;
var options = {
    legend: {
        show: false
    },
    yaxis: {
        autoscaleMargin: 0.05
    },
    xaxis: {
        autoscaleMargin: 0.05
    },
    grid: {
        show: false, //skrij osi
        hoverable: true,
        clickable: true
    }
};

var plotData;
function setUpGraph(placeholder, data) {
    plotData = [];

    json = data[0];
    tocke = data[1];

    data = [];
    for (var i = 0; i < json.length; i += 2) {
        data.push([json[i + 1], json[i]]);
    }

    plotData.push(
            {
                label: 'podatki',
                data: data,
                lines: {
                    show: true,
                    lineWidth: 2
                }});
    plotData.push({
        label: "selected",
        data: tocke,
        points: {
            show: true,
            fillColor: 'red',
            radius: 8
        }
    });
    plot = $.plot(placeholder, plotData, options);
}



function showTooltip(x, y, contents) {
    $('<div id="tooltip" contenteditable="true">' + contents + '</div>').css({
        position: 'absolute',
        display: 'none',
        top: y + 5,
        left: x + 5,
        border: '1px solid #fdd',
        padding: '2px',
        'background-color': '#fee',
        opacity: 0.80
    }).appendTo("body").fadeIn(200);
}

var previousPoint = null;
function onHover(event, pos, item) {
    $("#x").text(pos.x.toFixed(2));
    $("#y").text(pos.y.toFixed(2));
    if (item && item.series.label === "selected") {
        if (previousPoint != item.datapoint) {
            previousPoint = item.datapoint;
            $("#tooltip").remove();
            var x = item.datapoint[0].toFixed(2),
                    y = item.datapoint[1].toFixed(2),
                    //set default content for tooltip
                    content = plotData[1].data[item.dataIndex][2];
            //now show tooltip
            showTooltip(item.pageX, item.pageY, content);
        }
    }
    else {
        $("#tooltip").remove();
        previousPoint = null;
    }

}

function onClick(event, pos, item) {
    if (item) {
        if (item.series.label === "podatki") {
            $("#clickdata").text("You clicked point " + item.dataIndex + ".");
            var komentar = prompt("Dodajte komentar", "");

            $.ajax({
                url: "/measurements/comment",
                type: "POST",
                data: {seriesExecutionId: debug.selectedExecution().id, text: komentar, timestamp: item.dataIndex},
                success: function(data) {
                    debug.addComment(data.comment);
                },
                error: function(data) {
                    console.log("error");
                }
            });

            //dodamo izbrano točko in na novo izrišemo graf

        } else {

            idToRemove = plotData[1].data[item.dataIndex][3];
            indexToRemove = item.dataIndex;
            $.ajax({
                url: "/measurements/comment",
                type: "DELETE",
                data: {id: idToRemove},
                success: function(data) {
                    debug.removeComment(indexToRemove);
                },
                error: function(data) {
                    console.log("error");
                }
            });
        }
    } else {
        $("#clickdata").text("Click mimo tocke.");
    }
}

function showTooltip(x, y, contents) {
    $('<div id="tooltip">' + contents + '</div>').css({
        position: 'absolute',
        display: 'none',
        top: y + 5,
        left: x + 5,
        border: '1px solid #fdd',
        padding: '2px',
        'background-color': '#fee',
        opacity: 0.80
    }).appendTo("body").fadeIn(100);
}