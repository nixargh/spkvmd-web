#!/usr/bin/env ruby
# encoding: utf-8
module SpkvmdClient
	require 'json'

	def spkvmdc_get_vm_list
		JSON.parse(spkvmdc_operate_vm(nil, 'list'))
	end
	
	def spkvmdc_force_get_vm_list
		JSON.parse(spkvmdc_operate_vm(nil, 'flist'))
	end

	def spkvmdc_start_vm(vm)
		spkvmdc_operate_vm(vm, 'start')
	end

	def spkvmdc_stop_vm(vm)
		spkvmdc_operate_vm(vm, 'stop')
	end

	def spkvmdc_get_vnc_settings(vm)
		full_config = spkvmdc_get_settings(vm)
		if full_config.has_key?('-vnc')
			vnc_port = full_config['-vnc'][0]
			vnc_port = 5900 + vnc_port.delete(':').to_i
		else
			vnc_port = nil
		end
	end

	def spkvmdc_get_settings(vm)
		JSON.parse(spkvmdc_operate_vm(vm, 'showconfig'))
	end

	def spkvmdc_vm_running?(vm)
		vm_list = spkvmdc_get_vm_list
		if vm_list[vm]['status'] == 'running'
			true
		else
			false
		end
	end

private
	
	def spkvmdc_operate_vm(vm, cmd)
		code, info = spkvmdc_ask_daemon "kvm #{cmd} #{vm}"
		if code == 0
			return info
		elsif code == 1
			raise info
		elsif code == 2
			raise "spkvmd answer that \"#{cmd}\" is \"#{info}\""
		else
			raise "Code unknown: #{code}"
		end
	end
	
	def spkvmdc_ask_daemon(cmd)
		require "socket"
		s = TCPSocket.open("192.168.1.10", 5418)
		s.puts cmd
		code, info = spkvmdc_read_answer(s)
		return code.to_i, info
	end

	def spkvmdc_read_answer(s)
		answer = s.gets.chomp.split('|', 2)
		code = answer[0]
		info = answer[1]
		return code, info
	end

#	def spkvmdc_parse_vm_list(vm_list_string)
#		vm_list = vm_list_string.split('}, ')
#		vm_list_hash = Hash.new
#		vm_list.each{|vm|
#			vm.delete!('{}" ')
#			vm = vm.split('=>',2)
#			vm_list_hash[vm[0]] = vm[1]
#		}
#		vm_list = Hash.new
#		vm_list_hash.each{|vm, info|
#			info = info.split(',')
#			info_hash = Hash.new
#			info.each{|inf|
#				inf = inf.split('=>')
#				info_hash[inf[0]] = inf[1]
#			}
#			vm_list[vm] = info_hash
#		}
#		vm_list
#	end
end
