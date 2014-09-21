class User
	@@redis_host = Rails.application.config.redis_host
	@@redis_port = Rails.application.config.redis_port

	@@user_ttl = Rails.application.config.user_ttl
	
	def self.check_user(username, uuid)
		redis_connection = Redis.new(:host => @@redis_host, :port => @@redis_port)
		user_entry = redis_connection.get("user:#{username}")

		puts "Redis returned #{user_entry}"
		
		if not user_entry.nil?
			entry_ttl = redis_connection.ttl("user:#{username}")
			puts "Entry has a ttl of #{entry_ttl}"
		end

		#No user with this name
		if user_entry.nil?
			puts "User #{username} not found"
			return { :status => "not_found" }
		#Username already exists, different uuid -- different user trying same name
		elsif user_entry != uuid
			puts "User #{username} found but UUID mismatch"
			return { :status => "uuid_mismatch" }
		#Username already exists, uuid match
		#Get lobby id if exists
		else	
			lobby = redis_connection.get("user:#{username}:currentLobby")
			puts "User #{username} found with matching UUID.  Lobby is #{lobby}"
			return { :status => "uuid_match", :lobby => lobby }
		end
	end
	
	def self.refresh_user(username, uuid)
		redis_connection = Redis.new(:host => @@redis_host, :port => @@redis_port)	

		user_entry = redis_connection.get("user:#{username}");
		
		if user_entry.nil? or user_entry != uuid
			puts "Attempted to refresh #{username} and found no redis entry or uuid mismatch"
			return { :success => false }
		end
		
		redis_connection.setex("user:#{username}", @@user_ttl, "#{uuid}");
		
		puts "Refreshed username #{username}"
		
		return { :success => true }
	end

	def self.create_user(username)
		redis_connection = Redis.new(:host => @@redis_host, :port => @@redis_port)	
		user_entry = redis_connection.get("user:#{username}");
		#Check user doesn't already exist in redis (should always call check_user first but preven malicious)
		if not user_entry.nil?
			return { :success => false }
		end
		
		#Create uuid to associate
		uuid = SecureRandom.uuid	
		puts "Generated uuid #{uuid} for #{username}"
		
		#Store entry
		redis_connection.setex("user:#{username}", @@user_ttl, "#{uuid}");

		return {:success => true , :uuid => uuid}

	end

	def self.destroy_user(username, uuid)
		redis_connection = Redis.new(:host => @@redis_host, :port => @@redis_port)	
		user_entry = redis_connection.get("user:#{username}");
		
		if user_entry.nil? or user_entry != uuid
			puts "Attempted to destroy #{username} and found no redis entry or uuid mismatch"
			return { :success => false }
		end
		
		redis_connection.del("user:#{username}")

		return { :success => true}
	end


end
