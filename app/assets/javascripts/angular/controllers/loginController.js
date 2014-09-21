angular.module('TSSSF').controller('loginController', ['userService', '$scope', function(userService, $scope) {
	$scope.requestUsername = "";
	$scope.errorMessage = ""
	$scope.login = function() {
		userService.checkUser($scope.requestUsername)
			.then(function(result) {
				switch(result.status) {
					case 'uuid_mismatch':
						alert("Username in use.");
						$scope.requestUsername = "";
						break;
					case 'uuid_match':
						//Lobby autojoin goes here
						console.log("We should switch to lobby here");
						$scope.switchToChat();
						break;
					case 'not_found':
						userService.createUser($scope.requestUsername).then(function(result) {
							if(result.success) {
								$scope.switchToChat();
							} else {
								alert("Failed creating user!");
								console.log("Failed creating user, only reason this would happen in create_user is record for name found in redis already");
							}
						});
						break;
					default:
						console.log("Something's fucky with check_user.  Status was: " + result.status);
						alert("Error checking username, try again (check console for details)!");
						break;
				}
			});
	};

	$scope.switchToChat = function(){
		$scope.$parent.switchPage('chat');
	};
}]);
