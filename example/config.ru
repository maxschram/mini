#\ -w -p 3000
require './app'
Rack::Handler::Mini.run App
