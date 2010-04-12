# require 'weaky'
# 
# views_path = File.join(File.dirname(__FILE__), 'views')
# Sinatra::Application.default_options.merge!(
#   :views => views_path,
#   :run => false,
#   :env => :production
# )
# 
# run Sinatra::Application



require 'weaky_app'

use Rack::ShowExceptions

run WeakyApp.new
