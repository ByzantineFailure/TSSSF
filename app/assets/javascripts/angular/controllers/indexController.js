angular.module('TSSSF').controller('indexController', ['userService', '$scope', function (userService, $scope) {
	console.log("controller executed!");

	var SCREENS = [ { screen: 'chat', url: '../templates/chat.html'}, { screen: 'login', url: '../templates/login.html' } ];
	
	$scope.userService = userService;
	$scope.username = $scope.userService.username;

	$scope.activePage = {};
	$scope.activePage.contentUrl = _.find(SCREENS, function(screen) { return screen.screen == 'chat'; } ).url;

	$scope.switchPage = function(page) {
		$scope.activePage.contentUrl = _.find(SCREENS, function(screen) { return screen.screen == page; }).url;
	};
}]);
