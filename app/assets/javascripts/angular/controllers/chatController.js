angular.module('TSSSF').controller('chatController', ['baseChannel', '$scope', function(baseChannel, $scope) {
	
	var MAX_MESSAGES_IN_CHAT = 15;

	$scope.messages = ['testSeed'];
	$scope.currentMessage = "";
	$scope.chatConnection = baseChannel.open('chat');
	
	//Socket event handlers
	$scope.getMessage = function(message) {
		$scope.messages.push(message.message);
		if($scope.messages.length > MAX_MESSAGES_IN_CHAT) {
			$scope.messages.shift();
		}
	};
	
	//Set socket event handlers
	$scope.chatConnection.setEvents([
		{ event: 'chat.new_message', 
		  handler: $scope.getMessage,
		}
	]);

	//Socket interactions
	$scope.sendChatMessage = function() {
		$scope.chatConnection.sendMessage('chat.new_message', { message: $scope.currentMessage });
		$scope.currentMessage = "";
	};
}]);
