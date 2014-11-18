/* This is a basic API for interacting with channels on the webserver.
   A channel connection is a special kind of websocket that will allow the
   server to broadcast to all other connections on the same channel.
*/
angular.module('TSSSF').factory('baseSocket', [ 'hostname', function baseSocketFactory(hostname) {
	var baseSocket = {
		dispatcher: undefined,
		channels: [],		
		
		/** 
		    Open a connection.
		    data: Data to pass to the opening event
		    openingEvent: function to execute upon opening the socket
		**/
		open: function(data, openingEvent) {
			var self = this;
			
			if(!self.dispatcher) {
				self.dispatcher = new WebSocketRails(hostname + '/websocket');
				
				if(openingEvent) {
					self.dispatcher.on_open = openingEvent(data);
				}
			}
			return self;
		},
		    
		/**
		   Open channels
		   channels: string[] -- list of channel names to subscribe to
		**/
		openChannels: function(channels) {
			var self = this;
			_.forEach(channels, function(channel) {
				self.channels.push({channelName: channel, channel: self.dispatcher.subscribe(channel) });
			});
		},
		
		/**
		    Close the socket.  We probably don't need this.
		**/
		close: function() {
			var self = this;
			if(!self.dispatcher) {
				console.log("Attempting to close an unopened socket");
				return;
			}
			self.dispatcher.trigger('closeSocket', {});
		},

		/** 
		   Set events for the socket.
		   Events is an array of the follow object:
		   	{ 
			  event: Name of the event the server will trigger
			  channel:  Optional.  If not falsey, will subscribe to the event on that channel
			  handler:  Function to execute
			}
		**/
		setEvents: function(events) {
			var self = this;
			if(!self.dispatcher) {
				console.log("Open the socket before setting events");
				return;
			}

			_.forEach(events, function(event) {
				if(event.channel) {
					var channelEntry = _.find(self.channels, function(channel) {
						return channel.channelName == event.channel;
					});
					if(!channelEntry) {
						console.log("Could not find channel " + event.channel);
						return;
					}
					
					channelEntry.channel.bind(event.event, event.handler);
				} else {
					self.dispatcher.bind(event.event, event.handler);
				}
			});
		},
		
		
		/** 
		   Unset events.
		   Takes an array of the following object:
		   	{ 
			  event: event name
			  channel: Optional.  If not falsey, will unsubscribe from the event on that channel
			}
		**/
		unsetEvents: function(events) {
			var self = this;
			if(!self.dispatcher) {
				console.log("Open the socket and set some events before unsetting");
				return;
			}
			_.forEach(events, function(event) {
				if(event.channel) {
					var channelEntry = _.find(self.channels, function(channel) {
						return channel.channelName == event.channel;
					});
					if(!channelEntry) {
						console.log("Could not find channel " + event.channel);
						return;
					}
					channelEntry.channel.unbind(event.event);
				} else {
					self.dispatcher.unbind(event.event);
				}
			});
		},
		
		/**
		   Sends a message on the socket.
		   If channel is not falsey will send the event on the given channel.
		**/
		sendMessage: function(messageType, data, channel) {
			var self = this;
			if(!self.dispatcher) {
				console.log("Open the socket before sending messages");
				return;
			}
			console.log("Sending message " + data.message + " with event " + messageType);
			if(channel) {
				var channel = _.find(self.channels, function(channel) {
					return channel.channelName == event.channel;
				});
				if(!channel) {
					console.log("Could not find channel " + event.channel);
					return;
				}
				channel.trigger(messageType, data);
			} else {
				self.dispatcher.trigger(messageType, data);
			}
		},
		sendSuccessFailureMessage: function(messageType, data, success, failure) {
			var self = this;
			if(!self.dispatcher) {
				console.log("Open the socket before sending messages");
				return;
			}
			console.log("Sending success/fail message " + data.message + " with event " + messageType);
			self.dispatcher.trigger(messageType, data, success, failure);
		},
	};

	return baseSocket;
}]);
