class RedisConnection
	@@redis_host = Rails.application.config.redis_host
	@@redis_port = Rails.application.config.redis_port

	def self.get_connection
		return Redis.new(:host => @@redis_host, :port => @@redis_port)
	end
end
