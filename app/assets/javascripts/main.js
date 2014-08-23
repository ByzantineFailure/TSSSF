angular.module('TSSSF', ['$routeProvider', function($routeProvider) {
	$routeProvider.otherwise({
		templateUrl: '../templates/index.html',
		controller: 'indexController'
	});
}]);
