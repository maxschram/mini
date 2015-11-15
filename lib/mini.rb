require 'rack'
require 'eventmachine'

class Mini
  attr_reader :app, :host, :port

  def initialize(app, options)
    @app = app
    @host = options[:Host] || 'localhost'
    @port = options[:Port] || 3000
  end

  def start
    puts "Listening on #{host}:#{port}"
    EventMachine.run do
      EventMachine.start_server(host, port, Connection, app, self)
    end
  end
end

module Rack
  module Handler
    class Mini
      def self.run(app, options = {})
        server  = ::Mini.new(app, options)
        server.start
      end
    end
  end
end

Rack::Handler.register('mini', 'Rack::Handler::Mini')

require 'mini/connection'

