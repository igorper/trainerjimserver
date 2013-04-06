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
    var kgs = $.map(array, function(impl) {
        return impl.num_repetitions * impl.weight;
    }).sum();

    if (kgs >= 1000) {
        return [(kgs / 1000).toFixed(1), 't'];
    } else {
        return [kgs, 'kg'];
    }
}


function Flatten(array) {
    return $.map(array, function(el) {
        return el.executions;
    });
}

function Duration(array) {
    var duration = $.map(array, function(impl) {
        return impl.duration_seconds;
    }).sum();

    if (duration >= 60) {
        return [Math.round(duration / 60), 'min'];
    } else {
        return [duration, 'sec'];
    }
}
;

$("document").ready(function() {
    var placeholder = $("#placeholder");
    var graphDrawn = false;

    $.getJSON('/users/list_trainees', function(data) {


        function StatisticsPanel(exerciseTypes, root) {
            var self = this;

            ////////////////////////////////////////////////////////////////////
            /// Operations:
            //
            /**
             * @returns {Array} [liftedAmount, unit]
             */
            self.getWeightLifted = function() {
                if (self.workoutSelected()) {
                    if (self.exerciseTypes.length > 0) {
                        return KilogramsLifted(Flatten(self.exerciseTypes));
                    }
                } else if (self.parent.selectedExercise() !== null) {
                    return KilogramsLifted(self.parent.selectedExercise().executions);
                }
                return [0, 'kg'];
            }
            /**
             * @returns {Array} [duration, unit]
             */
            self.getDuration = function() {
                if (self.workoutSelected()) {
                    if (self.exerciseTypes.length > 0) {
                        return Duration(Flatten(self.exerciseTypes));
                    }
                } else if (self.parent.selectedExercise() !== null) {
                    return Duration(self.parent.selectedExercise().executions);
                }
                return [0, 'sec'];
            }

            ////////////////////////////////////////////////////////////////////
            /// Fields:
            //
            self.parent = root;
            self.exerciseTypes = exerciseTypes;


            self.exerciseSelected = ko.observable(false);
            self.workoutSelected = ko.computed(function() {
                return !self.exerciseSelected();
            });

            self.toggle = function() {
                return self.exerciseSelected(!self.exerciseSelected());
            };

            self.workoutDonePercentage = 86;

            self.weightLifted = ko.computed(function() {
                return self.getWeightLifted()[0];
            });

            self.weightLiftedUnit = ko.computed(function() {
                return self.getWeightLifted()[1];
            });

            self.duration = ko.computed(function() {
                return self.getDuration()[0];
            });

            self.durationUnit = ko.computed(function() {
                return self.getDuration()[1];
            });
        }

        function CommentsViewModel(parent) {
            ///Comments view model got 2 main states.
            ///1) No comments.
            ///2) The user commented but trainer didnt reply yet.
            ///3) Trainer replied to the user.

            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            ///Fields
            ///
            ///            
            ///
            var self = this;
            self.parent = parent;
            self.comments = ko.observableArray();
            self.question = ko.observable();

            ///Not yet implemented so always set to false from the start
            self.answered = ko.observable(false);
            self.replyFormVisible = ko.observable(false);

            self.inputText = ko.observable("");
            self.answer = ko.observable();

            self.clear = function() {
                self.answered(false);
                self.inputText("");
                self.answer(null);
                self.question(null);
            };

            self.setup = function(data) {
                self.clear();
                ko.utils.arrayPushAll(self.comments, data);


                //If no comments leave everything
                if (data.length > 0) {
                    ///Check if ID of selected user is same as commentators id

                    ///If last comment is by User, we allow replying
                    if (data[0].sender_id === self.parent.selectedUser().id() || data.length === 1) {
                        self.question(data[0]);
                    } else
                    {
                        ///Otherwise post is answered, and we set the answer value
                        self.question(data[1]);
                        self.answer(data[0]);
                        self.answered(true);
                    }
                }
            };

            self.anyComments = ko.computed(function() {
                return self.comments().length > 0;
            });



            self.toggleReply = function() {
                self.replyFormVisible(!self.replyFormVisible());
            };


            self.postReply = function() {
                text = self.inputText();
                measurementId = self.parent.measurement().id;
                self.toggleReply();


                $.ajax({
                    url: "/conversations/new",
                    data: {text: text, measurement_id: measurementId},
                    type: "POST",
                    success: function(data) {
                        $.getJSON("/conversations/list_by_measurement/" + measurementId + ".json", function(data) {
                            self.parent.commentsVM.setup(data);
                        });
                    }});
            };

            self.replyInputOn = ko.observable(false);
            self.replyToggle = function() {
                self.replyInputOn(!self.replyInputOn());
            };
        }

        function CalendarViewModel(root) {
            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            ///Fields
            ///
            ///
            ///

            var self = this;
            self.parent = root;
            self.calendar = ko.observable([]);
            self.currentMonthIndex = ko.observable(0);
            self.selectedDay = ko.observable();

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

                    measurementId = el.measurements[0].id;
                    $.getJSON("/dashboard/measurement/" + measurementId, function(data) {

                        self.parent.exerciseTypes(data.types);
                        self.parent.measurement(data.measurement);

                        graphcomments = data.measurement.measurement_comment;
                        measurementData = eval(data.measurement.data);

                        self.parent.clearGraphs();
                        self.parent.statistics(new StatisticsPanel(data.types, self.parent));

                        ///Select first exercise type
                        self.parent.onExerciseClick(self.parent.exerciseTypes()[0]);

                        ///Loads comments for given measurement
                        $.getJSON("/conversations/list_by_measurement/" + measurementId + ".json", function(data) {
                            self.parent.commentsVM.setup(data);
                        });
                    });
                }
            };
        }
        ;




        function UsersViewModel(parent) {
            var self = this;
            self.parent = parent;
            debug = this;

            self.dateFormat = function(time) {
                return $.datepicker.formatDate('dd, MM, yy', new Date(time));
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
                self.measurement(null);
                self.statistics(null);
                self.clearGraphs();
                self.commentsVM.clear();
            };

            ///Users display
            self.users = ko.mapping.fromJS(data);
            self.selectedUser = ko.observable(null);

            self.commentsVM = new CommentsViewModel(self);
            self.calendarVM = new CalendarViewModel(self);
            self.statistics = ko.observable(null);

            ///Measurements
            self.measurement = ko.observable(null);
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

            ///Triggers when new exercise type is selected.
            ///Selects first series by default.
            self.onExerciseClick = function(element) {
                self.selectedExercise(element);
                self.exerciseExecutions(element.executions);
                self.onGraphChangeButton(element.executions[0]);
            };

            ///Trigers when new series is selected
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

            ///Event that triggers when new user is selected
            self.selectUsers = function(element) {
                if (element !== self.selectedUser()) {
                    self.selectedUser(element);
                    self.clearGraphs();
                    self.exerciseTypes([]);


                    $.getJSON("/dashboard/exercisedates/" + element.id() + ".json", function(data) {
                        self.calendarVM.setup(data);
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



function showTooltip2(x, y, contents) {
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
;

var previousPoint = null;
function onHover(event, pos, item) {
    $("#x").text(pos.x.toFixed(2));
    $("#y").text(pos.y.toFixed(2));
    if (item && item.series.label === "selected") {
        if (previousPoint !== item.datapoint) {
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
var el;

///Draws the popover form
function popover(x, y, fadeTime, onClick) {
    console.log("popover");
    var element = $('<div class="popover-box"><textarea class="input" id="graph-input" placeholder="Type your comment here....." ></textarea><input type="submit" id="close" value="Close"/><input type="submit" id="post" value="Post"/></div>').css({
        position: 'absolute',
        display: 'none',
        top: y + 5,
        left: x + 5
    }).appendTo("body");
    element.fadeIn(fadeTime);
    element.find("#close").click(function() {
        element.fadeOut(fadeTime, function() {
            element.remove();
        });

    });

    element.find("#post").click(function() {
        komentar = element.find("textarea").val();
        onClick(komentar);
        element.remove();
    });
}

function onClick(event, pos, item) {
    if (item) {
        if (item.series.label === "podatki") {
            $("#clickdata").text("You clicked point " + item.dataIndex + ".");

            popover(item.pageX, item.pageY, 100, function(komentar) {
                $.ajax({
                    url: "/measurements/comment",
                    type: "POST",
                    data: {seriesExecutionId: debug.selectedExecution().id, text: komentar, timestamp: item.dataIndex},
                    success: function(data) {
                        debug.addComment(data.comment);
                        el.fadeOut(100);
                    },
                    error: function(data) {
                        console.log("error");
                        el.fadeOut(100);
                    }
                });
            });
        } else {

            var del = $('<div class="popover-delete-box"><span>Are you sure you want to delete this comment.</span><div class="inputs"><input type="submit" id="delete" value="Yes!"/><input type="submit" id="close" value="No"/></div></div></div>').
                    css({
                position: 'absolute',
                display: 'none',
                top: item.pageY + 5,
                left: item.pageX + 5
            }).appendTo("body");
            del.fadeIn(100);
            del.find("#close").click(function() {
                del.fadeOut(100, function() {
                    del.remove();
                });

            });

            del.find("#delete").click(function() {
                idToRemove = plotData[1].data[item.dataIndex][3];
                indexToRemove = item.dataIndex;
                $.ajax({
                    url: "/measurements/comment",
                    type: "DELETE",
                    data: {id: idToRemove},
                    success: function(data) {
                        debug.removeComment(indexToRemove);
                        del.remove();
                    },
                    error: function(data) {
                        console.log("error");
                        del.remove();
                    }
                });
            });
        }
    }
}

function showTooltip(x, y, contents) {
    $('<div id="tooltip" class="graph-comment top">' + contents + '</div>').css({
        position: 'absolute',
        display: 'none',
        top: y + 15,
        left: x - 30,
        'background-color': '#fee',
        opacity: 0.80
    }).appendTo("body").fadeIn(100);



}