class VmsController < ApplicationController
	include SpkvmdClient

	def index
		@title = 'VM\'s List'
		@top_result = SpkvmdClient.test
	end
end
