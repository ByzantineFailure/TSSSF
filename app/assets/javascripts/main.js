/* Declare our module */
angular.module('TSSSF', []);

/* Set up our routes */
angular.module('TSSSF').config(['$routeProvider', function($routeProvider) {
	console.log("config executed!");
	$routeProvider.otherwise({
		templateUrl: '../templates/index.html',
		controller: 'indexController'
	});
}]);

