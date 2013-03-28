class VmsController < ApplicationController
	before_filter :authenticate
	include SpkvmdClient

	def index
		@title = 'VM\'s List'
		begin
			@vm_list = get_vm_list
			#flash[:success] = "#{get_vm_list.length} virtual machines listed."
		rescue
			flash[:error] = "Can't get VM list: #{$!}"
			redirect_to root_path
		end
	end

	def startvm
		operate_vm('start'){|vm| start_vm(vm)}
	end

	def stopvm
		operate_vm('stop'){|vm| stop_vm(vm)}
	end

private

	def operate_vm(cmd_name)
		begin
			vm = params[:vm]
			yield vm
			flash[:success] = "VM #{vm} #{cmd_name}ed."
		rescue
			flash[:error] = "Can't #{cmd_name} VM #{vm}: #{$!}"
		end
		sleep 1
		redirect_to vms_path
	end
end
