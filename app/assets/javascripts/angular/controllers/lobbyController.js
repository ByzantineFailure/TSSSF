angular.module('TSSSF').controller('lobbyController', ['baseSocket', '$scope', function(baseSocket, $scope) {
	$scope.socket = baseSocket;
	baseSocket.open();
}]);
