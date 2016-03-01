var enTranslations = {
  WORKOUTS_INSTRUCTION_TITLE: 'Workouts'
};

var slTranslations = {
  WORKOUTS_INSTRUCTION_TITLE: 'Vadbe'
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
