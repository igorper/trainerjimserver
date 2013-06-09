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
            return 'assets/workouts/Treningi_template_' + ((parseInt(idx()) % 5) + 1).toString() + '.png';
        }
    }

    function Series(id, repeat_count, rest_time, weight) {
        var self = this;

        self.id = id;
        self.repeat_count = ko.observable(repeat_count);
        self.rest_time = ko.observable(rest_time);
        self.weight = ko.observable(weight);

        // Constants:
        var weight_increment = 5;
        var rest_time_increment = 5;
        var reps_increment = 1;

        // Operations
        self.increaseReps = function() {
            self.repeat_count(self.repeat_count() + reps_increment);
        }
        self.decreaseReps = function() {
            self.repeat_count(Math.max(self.repeat_count() - reps_increment, 0));
        }
        self.increaseWeight = function() {
            self.weight(self.weight() + weight_increment);
        }
        self.decreaseWeight = function() {
            self.weight(Math.max(self.weight() - weight_increment, 0));
        }
        self.increaseRestTime = function() {
            self.rest_time(self.rest_time() + rest_time_increment);
        }
        self.decreaseRestTime = function() {
            self.rest_time(Math.max(self.rest_time() - rest_time_increment, 0));
        }
    }

    function Exercise(id, exercise_type, series) {
        var self = this;

        // Fields
        self.id = id;
        self.series = ko.observableArray(series);
        self.series.selected = (series && series.length > 0) ? ko.observable(series[0]) : ko.observable();
        self.exercise_type = ko.observable(exercise_type);

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
        return new Exercise(exJson.id, exerciseTypeFromJson(exJson.exercise_type), multiSeriesFromJson(exJson.series));
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
        self.exercise_types = ko.observableArray(); // type: [ExerciseType]
        self.my_templates = ko.observableArray(); // type: [TrainingTemplate]
        self.templates = ko.observableArray(); // type: [TrainingTemplate]
        self.selected_training = ko.observable(); // type: TrainingTemplate

        // Operations
        self.deleteTraining = function() {
            $('#delete-confirmation').modal('hide');
            self.clearTraining();
            window.location = '#';
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
        
        self.refresh = function () {
            self.refreshExerciseTypes()
            self.refreshGlobalTemplates()
            self.refreshMyTemplates()
            self.selected_training(null);
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
        }).run();
    }

    var workoutsVV = new WorkoutsViewModel();
    pager.extendWithPage(workoutsVV);
    ko.applyBindings(workoutsVV);
    pager.start();
});