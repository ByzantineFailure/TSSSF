angular.module('TSSSF').controller('chatController', 
['baseSocket', '$scope', function(baseChannel, $scope) {
	
	var MAX_MESSAGES_IN_CHAT = 15;

	$scope.messages = [];
	$scope.currentMessage = "";
	$scope.channel = 'chat';
	$scope.chatConnection = baseChannel.open($scope.channel);

	$scope.chatConnection.openChannels([$scope.channel]);
	
	//Socket event handlers
	$scope.getMessage = function(message) {
		console.log("Received message reply: " + message.message);
		$scope.messages.push({ message: message.message, timestamp: new Date() } );
		if($scope.messages.length > MAX_MESSAGES_IN_CHAT) {
			$scope.messages.shift();
		}
		$scope.$digest();
	};
	
	//Set socket event handlers
	$scope.chatConnection.setEvents([
		{ event: 'chat.new_message', 
		  channel: $scope.channel,
		  handler: $scope.getMessage,
		}
	]);

	//Socket interactions
	$scope.sendChatMessage = function() {
		$scope.chatConnection.sendMessage('chat.new_message', { message: $scope.currentMessage , channelId: $scope.channel });
		$scope.currentMessage = "";
	};
}]);
