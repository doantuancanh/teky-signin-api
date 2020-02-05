class HomeController < ApplicationController
	def index
		render json: { message: "You are Signed in"}
	end
end
