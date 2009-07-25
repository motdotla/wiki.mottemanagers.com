require 'weaky'

set :run, false
set :environment, :production

FileUtils.mkdir_p 'log' unless File.exists?('log')
log = File.new("log/sinatra.log", "a")
$stdout.reopen(log)
$stdout.reopen(log)

run Sinatra::Application
