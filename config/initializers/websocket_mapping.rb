WebsockterRails::EventMap.describe do
	subscribe :client_connected, to: WebsocketController, with_method :client_connected
	subscribe :new_message, to: WebsocketController, with_method :new_message
	subscribe :client_disconnected, to: WebsocketController, with_method :client_disconnected

