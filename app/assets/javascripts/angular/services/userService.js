/* User functionality */

angular.module('TSSSF').service('userService', ["hostname", "userCookieTtl", function UserServiceFactory(hostname, userCookieTtl) {
	var usernameCookieField = "TSSSF_username";
	var usernameUuidCookieField = "TSSSF_usernameUuid";

	var userService = {
		hostname: hostname,
		
		/**
		 * Returns a promise with a success/fail attribute on it.
		 * If successful will also return lobby ID of the user in the promise.
		 **/
		checkUser: function(username, uuid) {
			var self = this;
			var checkUuid = uuid ? uuid : self.userUuid;
			return $.ajax({
				type: 'GET',
				url: 'http://' + self.hostname + '/user/check/' + username + '?uuid=' + checkUuid,
				accepts: 'application/json, text/json'
			});
		},
	
		//Attempts to create user for given username and set fields on service
		//Returns a promise with the result
		createUser: function(username) {
			var self = this;
			return $.ajax({
				type: 'POST',
				url: 'http://' + self.hostname + '/user/create/' + username,
				accepts: 'application/json, text/json'
			}).then(function(response) {
				if(response.success) {
					self.username = username;
					self.userUuid = response['uuid'];
					self.refreshCookie();
					return $.Deferred().resolve(response);
				} else {
					console.log("Failed call to create user!");
					return $.Deferred().resolve(response);
				}
			});
		},
		destroyUser: function() {
			var self = this;
			return $.ajax({
				type: 'POST',
				url: 'http://' + hostname + 'user/destroy/' + self.username + '?uuid=' + self.userUuid,
				accepts: 'application/json, text/json'
			}).then(function(response) {
				self.clearCookie();
				return $.Deferred().resolve(response);
			});;
		},
		refreshUser: function() {
			var self = this;
			self.refreshServerUser().then(function(result) {
				if(result.success) {
					self.refreshCookie();
				} else {
					console.log("Didn't succeed refreshing user " + self.username + " with uuid " + self.userUuid + " !  Not refreshing cookie.");
				}
			});
		},
		refreshServerUser: function() {
			var self = this;
			return $.ajax({
				type: 'POST',
				url: 'http://' + self.hostname + '/user/refresh/' + self.username + '?uuid=' +self.userUuid,
				accepts: 'application/json, text/json'
			});

		},
		refreshCookie: function() {
			var self = this;
			self.username = self.username;
			self.userUuid = self.userUuid;
		},
		clearCookie: function() { 
			var self = this;
			self.username = "";
			self.userUuid = "";
		}
		
	};
	var getCookieExpiry = function() {
		var now = new Date();
		var expiry = now.setMinutes(now.getMinutes() + 5);
		return expiry
	};

	Object.defineProperty(userService, 'username', {
		get: function() { 
			return docCookies.getItem(usernameCookieField);
		},
		set: function(newValue) { 
			docCookies.setItem(usernameCookieField, newValue, getCookieExpiry());
		},
		writeable: true
	});
	Object.defineProperty(userService, 'userUuid', {
		get: function() { 
			return docCookies.getItem(usernameUuidCookieField);
		},
		set: function(newValue) {
			docCookies.setItem(usernameUuidCookieField, newValue, getCookieExpiry());
		},
		writeable: true
	});
	return userService;
}]);
