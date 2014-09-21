require 'json'
require 'user'
require 'lobby'

class LobbyinfoController < WebsocketRails::BaseController
	@@lobby_info_channel = :lobby_info
	
	def create_lobby
		lobby_name = message[:lobby_name]
		username = message[:username]
		uuid = Lobby.create_lobby(lobby_name, username)
		
		if uuid == ""
			trigger_failure( { :success => false, :reason => "already_exists" } )
			return
		end

		lobby = Lobby.get_lobby(lobby_name)
		trigger_success(lobby)
		WebsocketRails[@@lobby_info_channel].trigger(:lobby_created, lobby, :namespace => @@lobby_info_channel)
	end

	#Eventually we'll need to add things like expansions and stuff.  
	#That's what this is for -- each change should propigate out
	def update_lobby
	end

	def join_lobby
		lobby_name = message[:lobby_name]
		username = message[:username]
		user_uuid = message[:user_uuid]

		check = User.check_user(username, user_uuid)

		if check.status != "uuid_match"
			trigger_failure( { :success => false, :reason => "bad_user" } )
		elsif not check.lobby.nil? or check.lobby != ""
			trigger_failure( { :success => false, :reason => "in_lobby" } )
		end
		
		Lobby.add_user(lobby_name, username)

		lobby = Lobby.get_lobby(lobby_name)

		trigger_success( { :success => true, :reason => "success" } )
		WebsocketRails[@@lobby_info_channel].trigger(:user_joined, lobby, :namespace => @@lobby_info_channel)
	end

	def leave_lobby
		lobby_name = message[:lobby_name]
		username = message[:username]
		user_uuid = message[:user_uuid]

		check = User.check_user(username, user_uuid)
		
		if check.status != "uuid_match"
			trigger_failure( { :success => false, :reason => "bad_user" } )
		elsif check.lobby.nil? or check.lobby == ""
			trigger_failure( { :success => false, :reason => "not_in_lobby" } )
		end

		Lobby.remove_user(lobby_name, username)

		lobby = Lobby.get_lobby(lobby_name)

		trigger_success( { :success => true, :reason => "success" } )
		WebsocketRails[@@lobby_info_channel].trigger(:user_left, lobby, :namespace => @@lobby_info_channel)
	end
end
