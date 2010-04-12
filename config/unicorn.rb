# http://superfeedr.posterous.com/superfeedr-blog-unicorn

# Use at least one worker per core
worker_processes 2

# Help ensure your application will always spawn in the symlinked "current" directory that Capistrano sets up
working_directory "/home/scottmotte/apps/wiki.mottemanagers.com/current"

# Listen on a Unix domain socket, use the default backlog size
listen "/home/scottmotte/apps/wiki.mottemanagers.com/unicorn.sock", :backlog => 1024

# Nuke workers after 30 seconds instead of 60 seconds (the default)
timeout 30
 
# Lets keep our process id's in one place for simplicity
pid "/home/scottmotte/apps/wiki.mottemanagers.com/shared/pids/unicorn.pid"

# Logs are very useful for trouble shooting, use them
stderr_path "/home/scottmotte/apps/wiki.mottemanagers.com/shared/unicorn_stderr.log"
stdout_path "/home/scottmotte/apps/wiki.mottemanagers.com/shared/unicorn_stdout.log"

# Use "preload_app true"
preload_app true
 

GC.respond_to?(:copy_on_write_friendly=) and GC.copy_on_write_friendly = true


before_fork do |server, worker|  
  old_pid = '/home/scottmotte/apps/wiki.mottemanagers.com/shared/pids/unicorn.pid.oldbin'
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    # someone else did our job for us
    end
  end

end

after_fork do |server, worker|
end