class VmsController < ApplicationController
	include SpkvmdClient

	def index
		@title = 'VM\'s List'
		@top_result = get_vm_list
	end

	def startvm
		vm = params[:vm]
		start_vm(vm)
		redirect_to vms_path
	end

	def stopvm
		vm = params[:vm]
		stop_vm(vm)
		redirect_to vms_path
	end
end
