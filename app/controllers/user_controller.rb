require "redis"
require "json"
require "user"

class UserController < ApplicationController
	#Check if the username the client has/wants exists
	#Return the user's lobby (if it exists) if it does
	def check_user
		username = params[:user_name]
		uuid = params[:uuid]
		
		result = User.check_user(username, uuid)

		respond_to do |format|
			 format.json { render :json => result }
		end
	end

	def create_user
		username = params[:user_name]
		puts "Creating user #{username}"
		
		result = User.create_user(username)

		respond_to do |format|
			format.json {render :json => result }
		end
	end
	
	#Refresh the user's redis entry
	#Return false success if the uuid doesn't match
	def refresh_user
		username = params[:user_name]
		uuid = params[:uuid]
		
		check = User.refresh_user(username, uuid)

		if not user_entry.nil?
			respond_to do |format|
				format.json {render :json => check }
			end
		end

	end

	def destroy_user
		username = params[:user_name]
		uuid = params[:uuid]

		result = User.destroy_user(username, uuid)
		
		respond_to do |format|
			format.json {render :json => result }
		end
	end
end
