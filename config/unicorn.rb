worker_processes 2
working_directory "/data/documents/development/spkvmd-web"

preload_app true

timeout 30

listen "/data/documents/development/spkvmd-web/tmp/sockets/unicorn.sock", :backlog => 64

pid "/data/documents/development/spkvmd-web/tmp/pids/unicorn.pid"

stderr_path "/data/documents/development/spkvmd-web/log/unicorn.stderr.log"
stdout_path "/data/documents/development/spkvmd-web/log/unicorn.stdout.log"

before_fork do |server, worker|
    defined?(ActiveRecord::Base) and
	    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
	defined?(ActiveRecord::Base) and
    	ActiveRecord::Base.establish_connection
end
