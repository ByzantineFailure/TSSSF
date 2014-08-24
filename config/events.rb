WebsocketRails::EventMap.describe do
	subscribe :client_connected, to: ChatController, with_method: :client_connected
	subscribe :client_disconnected, to: ChatController, with_method: :client_disconnected

	namespace :chat do
		subscribe :new_message, to: ChatController, with_method: :new_message
	end
end
