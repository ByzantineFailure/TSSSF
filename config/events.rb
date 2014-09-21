WebsocketRails::EventMap.describe do
	subscribe :client_connected, to: ChatController, with_method: :client_connected
	subscribe :client_disconnected, to: ChatController, with_method: :client_disconnected

	namespace :chat do
		subscribe :new_message, to: ChatController, with_method: :new_message
	end
	
	namespace :lobby_info do
		subscribe :create_lobby, to: LobbyinfoController, with_method: :create_lobby
		subscribe :join_lobby, to: LobbyinfoController, with_method: :join_lobby
		subscribe :leave_lobby, to: LobbyinfoController, with_method: :join_lobby

	end
end
