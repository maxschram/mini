require 'socket'
require 'rack'
require 'stringio'
require 'byebug'

class WebServerLite
  attr_reader :app, :host, :port
  def initialize(app, host: 'localhost', port: 3000)
    @app = app
    @host = host
    @port = port
  end

  def start
    tcp_server = TCPServer.new(host, port)

    puts "Server listening on #{host}:#{port}"
    loop do
      Thread.start(tcp_server.accept) do |socket|
        # socket = tcp_server.accept
        request = socket.gets
        response = ''

        puts request

        env = new_env(*request.split)
        status, headers, body = app.call(env)

        response << "HTTP/1.1 #{status} #{status}\r\n"
        headers.each do |k, v|
          response << "#{k}: #{v}\r\n"
        end
        response << "Connection: close\r\n"

        socket.print response
        socket.print "\r\n"

        body.each do |chunk|
          socket.print chunk
        end

        socket.close
      end
    end
  end

  def new_env(method, location, *args)
    {
      'REQUEST_METHOD'   => method,
      'SCRIPT_NAME'      => '',
      'PATH_INFO'        => location,
      'QUERY_STRING'     => location.split('?').last,
      'SERVER_NAME'      => host,
      'SERVER_PORT'      => port,
      'rack.version'     => Rack.version.split('.'),
      'rack.url_scheme'  => 'http',
      'rack.input'       => StringIO.new(''),
      'rack.errors'      => StringIO.new(''),
      'rack.multithread' => false,
      'rack.run_once'    => false
    }
  end
end

module Rack
  module Handler
    class WebServerLite
      def self.run(app, options = {})
        server = ::WebServerLite.new(app)
        server.start
      end
    end
  end
end

Rack::Handler.register('webserver_lite', 'Rack::Handler::WebServerLite')
