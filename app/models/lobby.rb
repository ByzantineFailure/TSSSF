require 'redis_connection'
require 'json'

class Lobby
	@@lobby_ttl = Rails.application.config.lobby_ttl
	@@lobby_list_key = "lobby_list"

	@redis_connection = RedisConnection.get_connection
	
	def self.get_lobby_list
		lobby_list = @redis_connection.get(@@lobby_list_key)
		
		if lobby_list.nil?
			return  Array.new
		else
			list = JSON.parse lobby_list
			return lobby_list[:lobbies]
		end
	end
	
	#Create a lobby without a leader or users
	def self.create_lobby(lobby_name)
		if not check_lobby(lobby_name).nil?
			puts "Lobby #{lobby_name} already exists."
			return ""
		end

		uuid = SecureRandom.uuid

		lobby_object = { :uuid => uuid, :users => Array.new, :leader => "" }	

		@redis_connection.setex("lobby:#{lobby_name}", @lobby_ttl, lobby_object.to_json) 
		
		Lobby.add_lobby_to_list(lobby_name)

		return uuid
	end
	
	#Create a lobby with a leader and user
	def self.create_lobby(lobby_name, username)
		Lobby.create_lobby(lobby_name)
		
		lobby = Lobby.get_lobby(lobby_name)
		lobby[:users].push(username)
		lobby[:leader] = username
		
		@redis_connection.setex("lobby:#{lobby_name}", @lobby_ttl, lobby.to_json) 

		return lobby[:uuid]
	end

	def self.get_lobby(lobby_name)
		lobby = @redis_connection.get("lobby:#{lobby_name}")
		if lobby.nil?
			return nil
		end
		
		lobby_object = JSON.parse lobby
		
		return lobby_object
	end
	
	#Just calls get_lobby
	def self.check_lobby(lobby_name)
		return Lobby.get_lobby_uuid(lobby_name)		
	end

	def self.add_user(lobby_name, user_name)
		lobby_entry = @redis_connection.get("lobby:#{lobby_name}")		
		if lobby_entry.nil?
			raise "Cannot add user to nonexistent lobby #{lobby_name}"
		end
		lobby = JSON.parse lobby_entry

		lobby[:users].push(user_name)
		@redis_connection.setex("lobby:#{lobby_name}", @lobby_ttl, lobby.to_json) 
		User.add_user_lobby_entry(user_name, lobby_name)
	end
	
	#Handle lobby leader handoff
	def self.remove_user(lobby_name, user_name)
		lobby_entry = @redis_connection.get("lobby:#{lobby_name}")		
		if lobby_entry.nil?
			raise "Cannot remove user from nonexistent lobby #{lobby_name}"
		end
		lobby = JSON.parse lobby_entry
			
		lobby[:users].delete(user_name)
		
		if lobby[:users].length == 0
			Lobby.delete_lobby(lobby_name)
			return
		end

		if lobby[:leader] == user_name
			lobby[:leader] = lobby[:users][0]
		end

		@redis_connection.setex("lobby:#{lobby_name}", @lobby_ttl, lobby.to_json) 
		User.remove_user_lobby_entry(user_name, lobby_name)
	end

	def self.delete_lobby(lobby_name)
		lobby = Lobby.get_lobby(lobby_name)
		if lobby.nil?
			raise "Deleting nonexistent lobby #{lobby_name}"
		end
		@redis_connection.delete("lobby:#{lobby_name}")
		Lobby.remove_lobby_from_list(lobby_name)
	end

	private

	def self.add_lobby_to_list(lobby_name)
		lobby_list = Lobby.get_lobby_list
		if lobby_list.include?(lobby_name)
			return
		else
			lobby_list.push(lobby_name)	
			entry = { :lobbies => lobby_list}
			@redis_connection.set(@lobby_list_key, entry.to_json)
		end
	end

	def self.remove_lobby_from_list(lobby_name)
		lobby_list = Lobby.get_lobby_list
		if not lobby_list.include?(lobby_name)
			return
		else
			lobby_list.delete(lobby_name)
			entry = { :lobbies => lobby_list }
			@redis_connection.set(@lobby_list_key, entry.to_json)
		end	
	end
end
