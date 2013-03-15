class VmsController < ApplicationController
	include SpkvmdClient

	def index
		@title = 'VM\'s List'
		@top_result = get_vm_list
	end
end
