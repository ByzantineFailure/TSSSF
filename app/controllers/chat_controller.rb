class ChatController < WebsocketRails::BaseController
	def client_connected
		puts "new client!"
	end
	
	def client_disconnected

	end

	def new_message
		text = message[:message]
		channelId = message[:channelId]
		new_message = {:message => message[:message] }
		puts "message is #{text}!"
		puts "channel is #{channelId}!" 
		
		if channelId != '' then
			puts "sending message to channel"
			channelSymbol = channelId.to_sym
			WebsocketRails[channelSymbol].trigger(:new_message, new_message, :namespace => :chat)
			puts "triggered to channel"
		else
			puts "sending message to individual"
			send_message :new_message, new_message, :namespace => :chat
			puts "sent to individual"
		end
	end

	def new_user

	end
end
