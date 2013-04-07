//= require knockout-2.2.1
//= require knockout.mapping

on_json_error_behaviour = alertOnJsonError;

$(function() {
    /////////////////////////////////////////////////////////////////////////////
    /// WORKOUTS
    //
    var workouts = $('.training.workouts');
    workouts.find('.selected-regime .exercises').sortable();
    workouts.find('.selected-regime .exercises').disableSelection();
    workouts.find('.selected-regime .exercises .series-list').sortable();
    workouts.find('.selected-regime .exercises .series-list').disableSelection();

    // KNOCKOUT MODELS:
    function TrainingTemplate(id, name) {
        var self = this;

        self.id = id;
        self.name = ko.observable(name);

        self.href = ko.computed(function() {
            if (self.id < 0) {
                return '#workout-templates';
            } else {
                return '#my-workout';
            }
        });
    }

    function Series() {
        var self = this;
    }

    function Exercise() {
        var self = this;
    }

    function Regime() {
        var self = this;
    }
    
    // Helper Methods
    function createDummyTrainingTemplate(message) {
        return new TrainingTemplate(-1, message ? message : 'Create or choose one <span class="underline">here</span>');
    }


    // KNOCKOUT VIEWMODEL:
    function WorkoutsViewModel() {
        var self = this;

        // Data
        self.my_templates = ko.observableArray(); // type: [TrainingTemplate]
        self.templates = ko.observableArray(); // type: [TrainingTemplate]
        self.selected_training = ko.observable(); // type: TrainingTemplate

        // Operations

        // Initialisation
        callJSON(training_templates_url, {}, function(templates) {
            self.templates($.map(templates, function(template) {
                return new TrainingTemplate(template.id, template.name);
            }));
        });

        callJSON(training_my_templates_url, {}, function(templates) {
            var my_templates = $.map(templates, function(template) {
                return new TrainingTemplate(template.id, template.name);
            });
            my_templates.push(createDummyTrainingTemplate());
            self.my_templates(my_templates);
        });
    }

    ko.applyBindings(new WorkoutsViewModel());
});