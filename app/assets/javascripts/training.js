//= require knockout-2.2.1
//= require knockout.mapping

$(function () {
   /////////////////////////////////////////////////////////////////////////////
   /// WORKOUTS (jQuery)
   //
   var workouts = $('.training.workouts');
   workouts.find('.selected-regime .exercises').sortable();
   workouts.find('.selected-regime .exercises').disableSelection();
   workouts.find('.selected-regime .exercises .series-list').sortable();
   workouts.find('.selected-regime .exercises .series-list').disableSelection();
});



/////////////////////////////////////////////////////////////////////////////
/// WORKOUTS PAGE (Knockout)
//

// MODELS:
function TrainingTemplate(id, name) {
    var self = this;
    
    self.id = id;
    self.name = ko.observable(name);
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


// VIEWMODEL:
function WorkoutsViewModel() {
    var self = this;
    
    // Data
    self.my_trainings = ko.observableArray([]); // type: TrainingTemplate
    self.templates = ko.observableArray([]); // type: TrainingTemplate
    
    self.selected_training = ko.observable();
    
    // Operations
}