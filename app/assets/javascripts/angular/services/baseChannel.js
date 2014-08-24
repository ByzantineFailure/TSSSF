/* This is a basic API for interacting with channels on the webserver.
   A channel connection is a special kind of websocket that will allow the
   server to broadcast to all other connections on the same channel.
*/
angular.module('TSSSF').factory('baseChannel', [ 'hostname', function baseChannelFactory(hostname) {
	var baseChannel = {
		dispatcher: undefined,
		channel: undefined,		

		open: function(channel, data, openingEvent) {
			var self = this;
			if(!channel) {
				console.log("Specify a channel to subscribe to!");	
			}

			self.dispatcher = new WebSocketRails(hostname + '/websocket');
			self.channel = self.dispatcher.subscribe(channel);
			if(openingEvent) {
				self.dispatcher.on_open = openingEvent(data);
			}
			return self;
		},
		
		close: function() {
			var self = this;
			if(!self.channel) {
				console.log("Attempting to close an unopened socket");
				return;
			}
			self.channel.trigger('closeSocket', {});
		},

		/* Events object:  [{ event: 'eventname', handler: somefunction(returndata) }] */
		setEvents: function(events) {
			var self = this;
			if(!self.channel) {
				console.log("Open the socket before setting events");
				return;
			}

			_.forEach(events, function(event) {
				self.channel.bind(event.event, event.handler);
			});
		},
		
		/* Takes an array of event name strings and unsets them */
		unsetEvents: function(events) {
			var self = this;
			if(!self.dispatcher) {
				console.log("Open the socket and set some events before unsetting");
				return;
			}
			_.forEach(events, function(event) {
				self.channel.unbind(event);
			});
		},

		sendMessage: function(messageType, data) {
			var self = this;
			if(!self.dispatcher) {
				console.log("Open the socket before sending messages");
				return;
			}
			console.log("Sending message " + data.message + " with event " + messageType);
			self.channel.trigger(messageType, data);
		},
	};

	return baseChannel;
}]);
