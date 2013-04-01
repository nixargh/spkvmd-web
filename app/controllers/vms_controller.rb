class VmsController < ApplicationController
	before_filter :authenticate
	include SpkvmdClient
	include VmsHelper

	def index
		@title = 'VM\'s List'
		begin
			@vm_list = spkvmdc_get_vm_list
			#flash[:success] = "#{get_vm_list.length} virtual machines listed."
		rescue
			flash[:error] = "Can't get VM list: #{$!}"
			redirect_to root_path
		end
	end

	def startvm
		operate_vm('start'){|vm| spkvmdc_start_vm(vm)}
	end

	def stopvm
		operate_vm('stop'){|vm| spkvmdc_stop_vm(vm)}
	end

	def vnc
		@title = 'VM\'s VNC'
		begin
			@host = 'magic-beans.org'
			@port = spkvmdc_get_vnc_settings(params[:vm])
		rescue
			flash[:error] = "Can't start VNC: #{$!}"
			redirect_to :back
		end
	end
end
