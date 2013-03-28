#!/usr/bin/env ruby
# encoding: utf-8
module SpkvmdClient
	def get_vm_list
		code, info = ask_daemon "kvm list"
		if code == 0
			return parse_vm_list(info)
		else
			raise info
		end
	end

	def start_vm(vm)
		spkvmd_client_operate_vm(vm, 'start')
	end

	def stop_vm(vm)
		spkvmd_client_operate_vm(vm, 'stop')
	end

private
	
	def spkvmd_client_operate_vm(vm, cmd)
		code, info = ask_daemon "kvm #{cmd} #{vm}"
		raise info if code != 0
		return code, info
	end
	
	def ask_daemon(cmd)
		require "socket"
		s = TCPSocket.open("192.168.1.10", 5418)
		s.puts cmd
		code, info = read_answer(s)	
		return code.to_i, info
	end

	def read_answer(s)
		code, info = s.gets.chomp.split('|', 2)
	end

	def parse_vm_list(vm_list_string)
		vm_list = vm_list_string.split('}, ')
		vm_list_hash = Hash.new
		vm_list.each{|vm|
			vm.delete!('{}" ')
			vm = vm.split('=>',2)
			vm_list_hash[vm[0]] = vm[1]
		}
		vm_list = Hash.new
		vm_list_hash.each{|vm, info|
			info = info.split(',')
			info_hash = Hash.new
			info.each{|inf|
				inf = inf.split('=>')
				info_hash[inf[0]] = inf[1]
			}
			vm_list[vm] = info_hash
		}
		vm_list
	end

	def parse_operation(string)
		
	end
end
