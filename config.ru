require 'weaky'

Sinatra::Application.default_options.merge!(
  :run => false,
  :env => :production
)

run Sinatra::Application
