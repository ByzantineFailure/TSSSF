/* This is a basic API for interacting with channels on the webserver.
   A channel connection is a special kind of websocket that will allow the
   server to broadcast to all other connections on the same channel.
*/
angular.module('TSSSF').factory('baseChannel', [ 'hostname', function baseChannelFactory(hostname) {
	var baseChannel = {
		dispatcher: undefined,
		channel: undefined,		

		open: function(channel, data, openingEvent) {
			if(!channel) {
				console.log("Specify a channel to subscribe to!");	
			}

			this.dispatcher = new WebSocketRails(hostname + '/websocket');
			this.channel = this.dispatcher.subscribe(channel);
			if(openingEvent) {
				this.dispatcher.on_open = openingEvent(data);
			}
			return this;
		},
		
		close: function() {
			if(!this.channel) {
				console.log("Attempting to close an unopened socket");
				return;
			}
			this.channel.trigger('closeSocket', {});
		},

		/* Events object:  [{ event: 'eventname', handler: somefunction(returndata) }] */
		setEvents: function(events) {
			if(!this.channel) {
				console.log("Open the socket before setting events");
				return;
			}

			_.forEach(events, function(event) {
				this.channel.bind(event.event, event.handler);
			});
		},
		
		/* Takes an array of event name strings and unsets them */
		unsetEvents: function(events) {
			if(!this.dispatcher) {
				console.log("Open the socket and set some events before unsetting");
				return;
			}
			_.forEach(events, function(event) {
				this.channel.unbind(event);
			});
		},

		sendMessage: function(messageType, data) {
			if(!this.dispatcher) {
				console.log("Open the socket before sending messages");
				return;
			}
			this.channel.trigger(messageType, data);
		},
	};

	return baseChannel;
}]);
