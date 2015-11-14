require 'rack'
require_relative 'server'

app = Proc.new do |env|
  ["200", {'Content-Type' => 'text/html'}, ["Hello world"]]
end

Rack::Server.start(
  app: app,
  server: 'webserver_lite'
)
