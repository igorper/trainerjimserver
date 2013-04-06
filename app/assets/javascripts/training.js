$(function () {
   /////////////////////////////////////////////////////////////////////////////
   /// WORKOUTS
   //
   var workouts = $('.training.workouts');
   workouts.find('.selected-regime .exercises').sortable();
   workouts.find('.selected-regime .exercises').disableSelection();
   workouts.find('.selected-regime .exercises .series-list').sortable();
   workouts.find('.selected-regime .exercises .series-list').disableSelection();
});