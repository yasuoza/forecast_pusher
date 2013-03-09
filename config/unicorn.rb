unicorn_user = 'yasu'
app = 'forecast_pusher'
app_path = "/home/#{unicorn_user}/Projects/Padrino/#{app}"
shared_path = "#{app_path}/shared"

worker_processes 4

user "yasu", "yasu"

working_directory "#{app_path}/current" # available in 0.94.0+

listen "/tmp/#{app}.sock", :backlog => 64

timeout 30

pid "#{shared_path}/pids/unicorn.pid" # available in 0.94.0+

stderr_path "#{shared_path}/log/unicorn.stderr.log"
stdout_path "#{shared_path}/log/unicorn.stdout.log"

preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

check_client_connection false

before_fork do |server, worker|
  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end
