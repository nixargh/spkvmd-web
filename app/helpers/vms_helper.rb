module VmsHelper
	include SpkvmdClient

	def running?(vm)
		spkvmdc_vm_running?(vm)
	end

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
