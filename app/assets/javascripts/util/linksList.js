var links = angular.module('util.links', []);

links.factory('isLinkActive', ['$state', function ($state) {
  return function (link) {
    return $state.includes(link.link) || !!link.activeUrls && link.activeUrls.some($state.includes);
  };
}]);
