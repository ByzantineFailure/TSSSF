require "redis"
require "json"

class UserController < ApplicationController
	
	@@redis_host = Rails.application.config.redis_host
	@@redis_port = Rails.application.config.redis_port
	

	@@user_ttl = Rails.application.config.user_ttl
	
	#Check if the username the client has/wants exists
	#Return the user's lobby (if it exists) if it does
	def check_user
		username = params[:user_name]
		uuid = params[:uuid]
		
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
			@check_user = { :status => "not_found" }
		#Username already exists, different uuid -- different user trying same name
		elsif user_entry != uuid
			puts "User #{username} found but UUID mismatch"
			@check_user = { :status => "uuid_mismatch" }
		#Username already exists, uuid match
		#Get lobby id if exists
		else	
			lobby = redis_connection.get("user:#{username}:currentLobby")
			puts "User #{username} found with matching UUID.  Lobby is #{lobby}"
			@check_user = { :status => "uuid_match", :lobby => lobby }
		end

		respond_to do |format|
			 format.json { render :json => @check_user }
		end
	end

	def create_user
		username = params[:user_name]
		puts "Creating user #{username}"
		#Check user doesn't already exist in redis (should always call check_user first but preven malicious)
		redis_connection = Redis.new(:host => @@redis_host, :port => @@redis_port)	
		user_entry = redis_connection.get("user:#{username}");

		if not user_entry.nil?
			respond_to do |format|
				format.json {render :json => {:success => false} }
			end
		end

		#Create uuid to associate
		uuid = SecureRandom.uuid	
		puts "Generated uuid #{uuid} for #{username}"

		#Store entry
		redis_connection.setex("user:#{username}", @@user_ttl, "#{uuid}");
		
		#Return uuid to user
		respond_to do |format|
			format.json {render :json => {:success => true, :uuid => uuid } }
		end
	end
	
	#Refresh the user's redis entry
	#Return false success if the uuid doesn't match
	def refresh_user
		username = params[:user_name]
		uuid = params[:uuid]
		redis_connection = Redis.new(:host => @@redis_host, :port => @@redis_port)	

		user_entry = redis_connection.get("user:#{username}");

		if user_entry.nil? or user_entry != uuid
			puts "Attempted to refresh #{username} and found no redis entry or uuid mismatch"
			respond_to do |format|
				format.json {render :json => {:success => false} }
			end
		end

		redis_connection.setex("user:#{username}", @@user_ttl, "#{uuid}");

		if not user_entry.nil?
			puts "Refreshed username #{username}"
			respond_to do |format|
				format.json {render :json => {:success => true} }
			end
		end

	end
end
