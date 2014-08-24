class ChatController < WebsocketRails::BaseController
	def client_connected
		puts "new client!"
	end
	
	def client_disconnected

	end

	def new_message
		puts "made it to the controller!"
		channel = WebsocketRails[message[:channel]]

		channel.trigger(:new_message, {:message => message.message, :namespace => :chat })
	end

	def new_user

	end
end
