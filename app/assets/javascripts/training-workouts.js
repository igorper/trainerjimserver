//= require knockout-2.2.1
//= require knockout.mapping

on_json_error_behaviour = alertOnJsonError;

$(function() {
    /////////////////////////////////////////////////////////////////////////////
    /// WORKOUTS
    //
    var workouts = $('.training.workouts');

    // KNOCKOUT MODELS:
    function TrainingTemplate(id, name) {
        var self = this;

        self.id = id;
        self.name = ko.observable(name);

        // Operations
        self.compareTo = function(other) {
            return self.name().localeCompare(other.name());
        }
        self.compareToById = function(other) {
            return self.id - other.id;
        }
    }

    function Series(id, repeat_count, rest_time, weight) {
        var self = this;

        self.id = id;
        self.repeat_count = ko.observable(repeat_count);
        self.rest_time = ko.observable(rest_time);
        self.weight = ko.observable(weight);

        // Operations
        self.increaseReps = function() {
            self.repeat_count(self.repeat_count() + 1);
        }
        self.decreaseReps = function() {
            if (self.repeat_count() > 0)
                self.repeat_count(self.repeat_count() - 1);
        }
        self.increaseWeight = function() {
            self.weight(self.weight() + 5);
        }
        self.decreaseWeight = function() {
            if (self.weight() > 5)
                self.weight(self.weight() - 5);
        }
        self.increaseRestTime = function() {
            self.rest_time(self.rest_time() + 1);
        }
        self.decreaseRestTime = function() {
            if (self.rest_time() > 0)
                self.rest_time(self.rest_time() - 1);
        }
    }

    function Exercise(id, exercise_type, order, series) {
        var self = this;

        self.id = id;
        self.name = ko.observable(name);
        self.order = ko.observable(order);
        self.series = ko.observableArray(series);
        self.exercise_type = ko.observable(exercise_type);

        // Operations
        self.removeSeries = function(series) {
            self.series.remove(series);
        }
        self.addSeries = function() {
            self.series.push(new Series(-1, 0, 0, 0));
        }
    }

    function Regime(id, name, exercises) {
        var self = this;

        self.id = id;
        self.name = ko.observable(name);
        self.exercises = ko.observableArray(exercises);

        // Operations
        self.removeExercise = function(exercise) {
            self.exercises.remove(exercise);
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
        return new Exercise(exJson.id, exerciseTypeFromJson(exJson.exercise_type), exJson.order, multiSeriesFromJson(exJson.series));
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


    // KNOCKOUT VIEWMODEL:
    function WorkoutsViewModel() {
        var self = this;

        // Data
        self.exercise_types = ko.observableArray(); // type: [ExerciseType]
        self.my_templates = ko.observableArray(); // type: [TrainingTemplate]
        self.templates = ko.observableArray(); // type: [TrainingTemplate]
        self.selected_training = ko.observable(); // type: TrainingTemplate

        // Operations
        self.onSelectTraining = function(trainingTemplate) {
            callJSON(training_my_template_url, {id: trainingTemplate.id}, function(t) {
                self.selected_training(regimeFromJson(t));

                workouts.find('.selected-regime .exercises').sortable();
                workouts.find('.selected-regime .exercises').disableSelection();
                workouts.find('.selected-regime .exercises .series-list').sortable();
                workouts.find('.selected-regime .exercises .series-list').disableSelection();

                $('html, body').animate({
                    scrollTop: $("#my-workout").offset().top
                }, 500);
            });
        }

        self.displayableIndex = function(idx) {
            return idx + 1;
        }

        // Initialisation
        callJSON(exercise_types_url, {}, function(exs) {
            self.exercise_types($.map(exs, function(et) {
                return new ExerciseType(et.id, et.name);
            }));
        });

        callJSON(training_templates_url, {}, function(templates) {
            self.templates($.map(templates, function(template) {
                return new TrainingTemplate(template.id, template.name);
            }));
        });

        callJSON(training_my_templates_url, {}, function(templates) {
            var my_templates = $.map(templates, function(template) {
                return new TrainingTemplate(template.id, template.name);
            });
            my_templates.sort(function(a, b) {
                return a.compareToById(b);
            });
            my_templates.push(createDummyTrainingTemplate());
            self.my_templates(my_templates);
        });
    }

    ko.applyBindings(new WorkoutsViewModel());
});