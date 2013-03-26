#!/usr/bin/env ruby
# encoding: utf-8
module SpkvmdClient

	def get_vm_list
		require "socket"
		s = TCPSocket.open("192.168.1.10", 5419)
		s.gets
		s.puts "kvm"
		s.gets
		s.puts "list"
		s.gets
		vm_list = s.gets.chomp
		s.puts "back"
		s.gets
		s.puts "exit"
		s.gets
		s.close
		vm_list = vm_list.split(':')[1]
		vm_list = vm_list.split('}, ')
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

	def start_vm(vm)
		require "socket"
		s = TCPSocket.open("192.168.1.10", 5418)
		s.puts "kvm start #{vm}"
		status = s.gets.chomp
	end

	def stop_vm(vm)
		require "socket"
		s = TCPSocket.open("192.168.1.10", 5418)
		s.puts "kvm stop #{vm}"
		status = s.gets.chomp
	end
end
