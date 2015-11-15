require 'rack'
require 'eventmachine'
require_relative 'lib/connection'

class Mini
  attr_reader :app, :host, :port

  def initialize(app, host: 'localhost', port: 3000)
    @app = app
    @host = host
    @port = port
  end

  def start
    EventMachine.run do
      EventMachine.start_server(host, port, Connection, app, self)
    end
  end
end

module Rack
  module Handler
    class Mini
      def self.run(app, options = {})
        server  = ::Mini.new(app)
        server.start
      end
    end
  end
end

Rack::Handler.register('mini', 'Rack::Handler::Mini')

