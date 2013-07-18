//= require knockout
//= require knockout.mapping
//= require knockout-sortable
//= require pager.min
//= require sammy.min

on_json_error_behaviour = alertOnJsonError;

$(function() {
    /////////////////////////////////////////////////////////////////////////////
    /// WORKOUTS
    //
    // KNOCKOUT MODELS:
    function TrainingTemplate(id, name, isMyTeplate) {
        var self = this;

        self.id = id;
        self.isMyTemplate = !!isMyTeplate;
        self.name = ko.observable(name);
        self.href = ko.computed(function() {
            return (id < 0) ? 'existing' : joinPaths(self.id, self.name());
        });

        // Operations
        self.compareTo = function(other) {
            return self.name().localeCompare(other.name());
        }
        self.compareToById = function(other) {
            return self.id - other.id;
        }
        self.getIconPath = function(idx) {
            return 'resource?name=workouts/Treningi_template_' + ((parseInt(idx()) % 5) + 1).toString() + '.png';
        }
    }

    function Series(id, repeat_count, rest_time, weight) {
        var self = this;

        self.id = id;
        self.repeat_count = ko.observable(repeat_count);
        self.rest_time = ko.observable(rest_time);
        self.weight = ko.observable(weight);
        self.dura = ko.observable("2,2");

        // Constants:
        var weight_increment = 5;
        var rest_time_increment = 5;
        var reps_increment = 1;

        // Operations
        self.increaseReps = function() {
            self.repeat_count(parseInt(self.repeat_count()) + reps_increment);
        }
        self.decreaseReps = function() {
            self.repeat_count(Math.max(parseInt(self.repeat_count()) - reps_increment, 0));
        }
        self.increaseWeight = function() {
            self.weight(parseInt(self.weight()) + weight_increment);
        }
        self.decreaseWeight = function() {
            self.weight(Math.max(parseInt(self.weight()) - weight_increment, 0));
        }
        self.increaseRestTime = function() {
            self.rest_time(parseInt(self.rest_time()) + rest_time_increment);
        }
        self.decreaseRestTime = function() {
            self.rest_time(Math.max(parseInt(self.rest_time()) - rest_time_increment, 0));
        }
    }

    function Exercise(id, guidance_type, exercise_type, series) {
        var self = this;

        // Fields
        self.id = id;
        self.guidance_type = ko.observable(guidance_type);
        self.series = ko.observableArray(series);
        self.series.selected = (series && series.length > 0) ? ko.observable(series[0]) : ko.observable();
        self.exercise_type = ko.observable(exercise_type);
        self.duration_up = 1.3;
        self.duration_middle = 1.2;
        self.duration_down = 0.5;
        self.duration_after = 0.8;
        self.shouldShowDetailsButton = ko.computed(function() {
            return !(self.guidance_type() === 'manual');
        });
        self.detailsButtonAction = ko.computed(function() {
            return "showTempoPopup";
        });

        // Operations
        self.removeSeries = function() {
            if (self.series.selected()) {
                var idxOf = self.series().indexOf(self.series.selected());
                self.series.remove(self.series.selected());
                if (self.series().length > 0) {
                    self.series.selected(self.series()[Math.max(0, idxOf - 1)]);
                } else {
                    workoutsVV.selected_training().removeExercise(self);
                    self.series.selected(null);
                }
            } else {
                workoutsVV.selected_training().removeExercise(self);
            }
        }

        self.addSeries = function() {
            self.series.push(new Series(-1, 0, 0, 0));
            if (!self.series.selected())
                self.series.selected(self.series()[0]);
        }

        self.setSelectedSeries = function(series) {
            self.series.selected(series);
        }

        self.isSelectedSeries = function(series) {
            return self.series.selected() == series;
        }

        self.setExerciseType = function(exType) {
            self.exercise_type(exType);
        }

        self.setGuidanceType = function(guType) {
            self.guidance_type(guType);
        }

        self.showAdvancedPopup = function(data, event) {
            if (self.guidance_type() == 'tempo') {
                console.log("popover");
                if ($("#popup-tempo-control").length) {
                    $("#popup-tempo-control").remove();
                    // also reset all animation data
                }

                // this values have to be the same as the ones defined in the '.popup-tempo' css
                var popup_width = 440;
                var popup_height = 420;

                var ref_offset = $(event.target).offset();
                var off_top = ref_offset.top - popup_height + 5;
                var off_left = ref_offset.left - popup_width + 5;

                var element = $(
                        '<div id="popup-tempo-control" class="popup-tempo">\n\
                <div class="outer-border">\n\
                    <div class="left">\n\
                        <div class="control-border" data-bind="click: startAnimation">\n\
                            <table id="tap_tempo_note"><tr><td>Tap to try!</td></tr></table>\n\
                            <div class="control-fill"></div>\n\
                        </div>\n\
                    </div>\n\
                    <div class="right">\n\
                        <table class="selector-controls">\n\
                        <tr>\n\
                            <td class="timer"><span class="segment">up:</span><input style="width:60px;" size="3" class="value" data-bind="value: duration_up" /></td>\n\
                            <td class="plus-minus-btns"><button class="plus-btn btn" data-bind="click: increaseDurationUp"><i class="icon-plus icon-white"></i></button><button class="minus-btn btn" data-bind="click: decreaseDurationUp"><i class="icon-minus icon-white"></i></button></td>\n\
                        </tr>\n\
                        <tr class="timer">\n\
                            <td class="timer"><span class="segment">middle:</span><input style="width:60px;" size="3" class="value" data-bind="value: duration_middle" /></td>\n\
                            <td class="plus-minus-btns"><button class="plus-btn btn" data-bind="click: increaseDurationMiddle"><i class="icon-plus icon-white"></i></button><button class="minus-btn btn" data-bind="click: decreaseDurationMiddle"><i class="icon-minus icon-white"></i></button></td>\n\
                        </tr>\n\
                        <tr class="timer">\n\
                            <td class="timer"><span class="segment">down:</span><input style="width:60px;" size="3" class="value" data-bind="value: duration_down" /></td>\n\
                            <td class="plus-minus-btns"><button class="plus-btn btn" data-bind="click: increaseDurationDown"><i class="icon-plus icon-white"></i></button><button class="minus-btn btn" data-bind="click: decreaseDurationDown"><i class="icon-minus icon-white"></i></button></td>\n\
                        </tr>\n\
                        <tr class="timer">\n\
                            <td class="timer"><span class="segment">after:</span><input style="width:60px;" size="3" class="value" data-bind="value: duration_after" /></td>\n\
                            <td class="plus-minus-btns"><button class="plus-btn btn" data-bind="click: increaseDurationAfter"><i class="icon-plus icon-white"></i></button><button class="minus-btn btn" data-bind="click: decreaseDurationAfter"><i class="icon-minus icon-white"></i></button></td>\n\
                        </tr>\n\
                        </table>\n\
                        <button class="save btn btn-success" data-bind="click: save">Save</button>\n\
                        <button id="cancel" class="cancel btn">Cancel</button>\n\
                    </div>\n\
                </div>\n\
            </div>'
                        ).css({
                    position: 'absolute',
                    display: 'none',
                    top: off_top,
                    left: off_left
                }).appendTo("body");
                element.fadeIn(FADE_TIME);
                element.find("#cancel").click(function() {
                    element.fadeOut(FADE_TIME, function() {
                        element.remove();
                    });
                });

                // scroll to have the whole popup in view
                if ($(window).scrollTop() - off_top >= 0) {
                    $('html, body').animate({
                        scrollTop: $("#popup-tempo-control").offset().top
                    }, FADE_TIME);
                }

                ko.applyBindings(new RepetitionDurationViewModel(self, self.duration_up, self.duration_middle, self.duration_down, self.duration_after), document.getElementById("popup-tempo-control"));
            } else if (self.guidance_type() == 'duration') {
                alert("We will show a duration settings popup!")
            }
        }

        self.toggleDetails = function(data, event) {
            var description = $(event.target).parents(".exercise").find(".description");
            if (description.is(":hidden")) {
                description.show("slow");
            } else {
                description.slideUp();
            }
        }
    }

    function Regime(id, name, exercises) {
        var self = this;

        self.id = id;
        self.name = ko.observable(name);
        self.exercises = ko.observableArray(exercises);

        // Operations
        self.onSaveClicked = function() {
            callJSON(training_save_workout_url, {workout: ko.toJSON(self)}, function(t) {
                window.location = '#';
                workoutsVV.refresh()
            });
        }

        self.onDeleteClicked = function() {
            $('#delete-confirmation').modal('show');
        }

        self.removeExercise = function(exercise) {
            self.exercises.remove(exercise);
        }

        self.addExerciseOfType = function(exType) {
            var newEx = new Exercise(-1, exType, []);
            newEx.addSeries();
            self.exercises.push(newEx);
            // Focus the newly added exercise:
            $('html, body').animate({
                scrollTop: $(".exercises .exercise:last-child").offset().top
            }, 500);
        }

        self.updateExercisePanel = function(elements) {
            for (var idx in elements) {
                $(elements[idx]).find('input.value').autoGrowInput({
                    comfortZone: 0,
                    minWidth: 0,
                    maxWidth: 60
                });
            }
        }
    }

    function ExerciseType(id, name) {
        var self = this;

        self.id = id;
        self.name = name;

        // Operations
        self.compareTo = function(other) {
            return self.name.localeCompare(other.name);
        }
    }

    // HELPER METHODS
    function seriesFromJson(seriesJson) {
        return new Series(seriesJson.id, seriesJson.repeat_count, seriesJson.rest_time, seriesJson.weight);
    }

    function multiSeriesFromJson(seriesJson) {
        return $.map(seriesJson, function(s) {
            return seriesFromJson(s);
        });
    }

    function exerciseTypeFromJson(extJson) {
        return new ExerciseType(extJson.id, extJson.name);
    }

    function exerciseFromJson(exJson) {
        return new Exercise(exJson.id, exJson.guidance_type, exerciseTypeFromJson(exJson.exercise_type), multiSeriesFromJson(exJson.series));
    }

    function exercisesFromJson(exsJson) {
        return $.map(exsJson, function(ex) {
            return exerciseFromJson(ex);
        });
    }

    function regimeFromJson(rJson) {
        return new Regime(rJson.id, rJson.name, exercisesFromJson(rJson.exercises));
    }

    function createDummyTrainingTemplate(message) {
        return new TrainingTemplate(-1, message ? message : 'Create or choose one <span class="underline">here</span>');
    }


    // MAIN VIEWMODEL:
    function WorkoutsViewModel() {
        var self = this;

        // Data
        self.exercise_types = ko.observableArray(); // type: ExerciseType[]
        self.my_templates = ko.observableArray(); // type: TrainingTemplate[]
        self.templates = ko.observableArray(); // type: TrainingTemplate[]
        self.selected_training = ko.observable(); // type: Regime
        self.all_guidance_types = ['tempo', 'duration', 'manual']


        // Operations
        self.deleteTraining = function() {
            $('#delete-confirmation').modal('hide');
            callJSON(
                    training_delete_workout_url,
                    {id: self.selected_training().id},
            function(response) {
                self.refresh();
                window.location = '#';
            })
        }

        self.clearTraining = function() {
            self.selected_training(null);
        }

        self.onSelectTraining = function(templateId) {
            // Is it a dummy training template? If so, scroll the user down to 
            // existing templates:
            if (templateId < 0) {
                $('html, body').animate({
                    scrollTop: $("#workout-templates").offset().top
                }, 500);
            } else {
                callJSON(training_my_template_url, {id: templateId}, function(t) {
                    self.selected_training(regimeFromJson(t));

                    $('html, body').animate({
                        scrollTop: $("#my-workout").offset().top
                    }, 500);
                });
            }
        }

        self.addExerciseOfType = function(exType) {
            if (!self.selected_training()) {
                self.selected_training(new Regime(-1, 'My new training', []));
            }
            self.selected_training().addExerciseOfType(exType);
        }

        self.displayableIndex = function(idx) {
            return idx + 1;
        }

        self.refresh = function() {
            self.refreshExerciseTypes()
            self.refreshGlobalTemplates()
            self.refreshMyTemplates()
            self.clearTraining();
        }

        // Initialisation
        self.refreshExerciseTypes = function() {
            callJSON(exercise_types_url, {}, function(exs) {
                self.exercise_types($.map(exs, function(et) {
                    return new ExerciseType(et.id, et.name);
                }));
            });
        }

        self.refreshGlobalTemplates = function() {
            callJSON(training_templates_url, {}, function(templates) {
                self.templates($.map(templates, function(template) {
                    return new TrainingTemplate(template.id, template.name, false);
                }));
            });
        }

        self.refreshMyTemplates = function() {
            callJSON(training_my_templates_url, {}, function(templates) {
                var my_templates = $.map(templates, function(template) {
                    return new TrainingTemplate(template.id, template.name, true);
                });
                my_templates.sort(function(a, b) {
                    return a.compareToById(b);
                });
                my_templates.push(createDummyTrainingTemplate());
                self.my_templates(my_templates);
            });
        }

        self.refresh()

        // Handling Sammy URL links:
        $.sammy(function() {
            this.get(getSammyLink('existing'), function() {
                self.onSelectTraining(-1);
            });
            this.get(getSammyLink(':id', ':name'), function() {
                self.onSelectTraining(this.params['id']);
            });
            this.get(getSammyLink('save'), function() {
                self.clearTraining();
            });
            this.get('/#', function() {
            });
        }).run();
    }

    function RepetitionDurationViewModel(selected_exercise, duration_up, duration_middle, duration_down, duration_after) {
        var REPEAT_ANIMATION = 2;

        var self = this;
        self.selected_exercise = selected_exercise;
        self.duration_up = ko.observable(duration_up);
        self.duration_middle = ko.observable(duration_middle);
        self.duration_down = ko.observable(duration_down);
        self.duration_after = ko.observable(duration_after);

        var duration_increment = 0.1;

        self.counter = 0;
        self.is_animating = false;

        // Operations
        self.increaseDurationUp = function() {
            was_animating = self.is_animating;

            self.resetAnimation();
            self.duration_up((parseFloat(self.duration_up()) + duration_increment).toFixed(1));
            if (was_animating) {
                self.startAnimation();
            }
        }
        self.decreaseDurationUp = function() {
            was_animating = self.is_animating;

            self.resetAnimation();
            self.duration_up(Math.max(parseFloat(self.duration_up() - duration_increment), 0).toFixed(1));

            if (was_animating) {
                self.startAnimation();
            }
        }

        self.increaseDurationMiddle = function() {
            was_animating = self.is_animating;

            self.resetAnimation();
            self.duration_middle((parseFloat(self.duration_middle()) + duration_increment).toFixed(1));

            if (was_animating) {
                self.startAnimation();
            }

        }
        self.decreaseDurationMiddle = function() {
            was_animating = self.is_animating;

            self.resetAnimation();
            self.duration_middle(Math.max(parseFloat(self.duration_middle() - duration_increment), 0).toFixed(1));

            if (was_animating) {
                self.startAnimation();
            }
        }

        self.increaseDurationDown = function() {
            was_animating = self.is_animating;

            self.resetAnimation();
            self.duration_down((parseFloat(self.duration_down()) + duration_increment).toFixed(1));

            if (was_animating) {
                self.startAnimation();
            }
        }
        self.decreaseDurationDown = function() {
            was_animating = self.is_animating;

            self.resetAnimation();
            self.duration_down(Math.max(parseFloat(self.duration_down() - duration_increment), 0).toFixed(1));

            if (was_animating) {
                self.startAnimation();
            }
        }

        self.increaseDurationAfter = function() {
            was_animating = self.is_animating;

            self.resetAnimation();
            self.duration_after((parseFloat(self.duration_after()) + duration_increment).toFixed(1));

            if (was_animating) {
                self.startAnimation();
            }
        }

        self.decreaseDurationAfter = function() {
            was_animating = self.is_animating;

            self.resetAnimation();
            self.duration_after(Math.max(parseFloat(self.duration_after() - duration_increment), 0).toFixed(1));

            if (was_animating) {
                self.startAnimation();
            }
        }

        self.repetitionUp = function() {
            if (self.counter < REPEAT_ANIMATION) {
                console.log("up");
                $(".control-fill").animate({height: "100%"}, self.duration_up() * 1000, self.repetitionMiddle);
            } else {
                self.resetAnimation();
            }
        }

        self.repetitionMiddle = function() {
            console.log("middle");
            $(".control-fill").animate({height: "100%"}, self.duration_middle() * 1000, self.repetitionDown);
        }

        self.repetitionDown = function() {
            $(".control-fill").animate({height: "0%"}, self.duration_down() * 1000, self.repetitionAfter);
        }

        self.repetitionAfter = function() {
            $(".control-fill").animate({height: "0%"}, self.duration_after() * 1000, self.repetitionUp);

            self.counter++;
        }

        self.resetAnimation = function() {
            self.is_animating = false;
            self.counter = 0;
            $(".control-fill").stop(true);
            $(".control-fill").height("0%");
            $("#tap_tempo_note").show();
        }

        self.startAnimation = function() {
            if (!self.is_animating) {
                self.is_animating = true;
                self.repetitionUp();
                $("#tap_tempo_note").hide();
            }
            else {
                self.resetAnimation();
            }
        }

        self.save = function() {

            // on save update the selected exercise duration values
            selected_exercise.duration_up = self.duration_up();
            selected_exercise.duration_middle = self.duration_middle();
            selected_exercise.duration_down = self.duration_down();
            selected_exercise.duration_after = self.duration_after();

            // and close the popup
            var element = $("#popup-tempo-control");
            element.fadeOut(FADE_TIME, function() {
                element.remove();
            });
        }
    }

    // to smooth the animations 
    var FADE_TIME = 500;

    var workoutsVV = new WorkoutsViewModel();
    pager.extendWithPage(workoutsVV);
    ko.applyBindings(workoutsVV);
    pager.start();
});