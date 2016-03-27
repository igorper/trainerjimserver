var enTranslations = {
  /** workouts-instructions.html **/
  WORKOUTS_INSTRUCTION_TITLE: 'Workouts',
  WORKOUTS_INSTRUCTIONS_STEP1_TITLE: 'Create a workout template',
  WORKOUTS_INSTRUCTIONS_STEP1_DESCRIPTION: 'Click the button below to create a new workout template.',
  WORKOUTS_INSTRUCTIONS_STEP1_BUTTON: 'Create new template',
  WORKOUTS_INSTRUCTIONS_STEP2_TITLE: 'Edit a workout template',
  WORKOUTS_INSTRUCTIONS_STEP2_DESCRIPTION: 'Click on an existing workout in the list on the left.',
  WORKOUTS_INSTRUCTIONS_STEP3_TITLE: 'Assign workouts to trainees',
  WORKOUTS_INSTRUCTIONS_STEP3_DESCRIPTION: 'Finally, assign workouts to your trainees, click on the button below.',
  WORKOUTS_INSTRUCTIONS_STEP3_BUTTON: 'My trainees',

  /** workouts.js.erb **/
  WORKOUTS_CTRL_HELPER_TEMPLATES: 'Templates',
  WORKOUT_CTRL_HELPER_SAVED_MSG_TITLE: 'Training saved',
  WORKOUT_CTRL_HELPER_SAVED_MSG_CONTENT: "Sucessfully saved ",
  WORKOUT_CTRL_HELPER_FETCH_ERR_MSG_TITLE: "Fetch workout error",
  WORKOUT_CTRL_HELPER_FETCH_ERR_MSG_CONTENT: "Unable to fetch the workout ",
  WORKOUT_CTRL_HELPER_DELETED_MSG_TITLE: 'Workout deleted',
  WORKOUT_CTRL_HELPER_DELETED_MSG_CONTENT: 'The workout was successfully deleted.',
  WORKOUT_CTRL_HELPER_ERR_DELETED_MSG_TITLE: "Workout not deleted",
  WORKOUT_CTRL_HELPER_ERR_DELETED_MSG_CONTENT: 'Could not delete the workout. Please try logging in again.'
};

var slTranslations = {
  /** workouts-instructions.html **/
  WORKOUTS_INSTRUCTION_TITLE: 'Treningi',
  WORKOUTS_INSTRUCTIONS_STEP1_TITLE: 'Ustvarite predlogo treninga',
  WORKOUTS_INSTRUCTIONS_STEP1_DESCRIPTION: 'Pritisnite gumb, da ustvarite novo predlogo treninga.',
  WORKOUTS_INSTRUCTIONS_STEP1_BUTTON: 'Ustvari predlogo treninga',
  WORKOUTS_INSTRUCTIONS_STEP2_TITLE: 'Uredi predlogo treninga',
  WORKOUTS_INSTRUCTIONS_STEP2_DESCRIPTION: 'Izberite obstoječ trening iz seznama na levi.',
  WORKOUTS_INSTRUCTIONS_STEP3_TITLE: 'Dodelite trening vadečim',
  WORKOUTS_INSTRUCTIONS_STEP3_DESCRIPTION: 'Pritisnite spodnji gumb, da dodelite trening vadečim.',
  WORKOUTS_INSTRUCTIONS_STEP3_BUTTON: 'Moji vadeči',

  /** workouts.js.erb **/
  WORKOUTS_CTRL_HELPER_TEMPLATES: 'Predloge',
  WORKOUT_CTRL_HELPER_SAVED_MSG_TITLE: 'Trening shranjen',
  WORKOUT_CTRL_HELPER_SAVED_MSG_CONTENT: "Shranjen ",
  WORKOUT_CTRL_HELPER_FETCH_ERR_MSG_TITLE: "Napaka treninga",
  WORKOUT_CTRL_HELPER_FETCH_ERR_MSG_CONTENT: "Napaka pridobivanja treninga ",
  WORKOUT_CTRL_HELPER_DELETED_MSG_TITLE: 'Brisanje treninga',
  WORKOUT_CTRL_HELPER_DELETED_MSG_CONTENT: 'Trening izbrisan.',
  WORKOUT_CTRL_HELPER_ERR_DELETED_MSG_TITLE: "Brisanje treninga",
  WORKOUT_CTRL_HELPER_ERR_DELETED_MSG_CONTENT: 'Trening ni izbrisan. Poskusite s ponovno prijavo.'
};

var translationsModule = angular.module('translations', ['pascalprecht.translate', 'ngCookies']);

translationsModule.config(['$translateProvider', function ($translateProvider) {
  $translateProvider.useLocalStorage();
  $translateProvider.translations('en', enTranslations);
  $translateProvider.translations('sl', slTranslations);
  $translateProvider.useSanitizeValueStrategy('sanitize');
  $translateProvider.registerAvailableLanguageKeys(
    ['en', 'sl'], {
      'en_*': 'en',
      'sl_*': 'sl'
    });
  $translateProvider.fallbackLanguage('en');
  $translateProvider.determinePreferredLanguage();
}]);