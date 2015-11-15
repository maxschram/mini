require 'eventmachine'
require 'rack'

class Connection < EventMachine::Connection
  attr_reader :env, :app, :server
  attr_accessor :status, :headers, :body

  def initialize(app, server)
    @app = app
    @server = server
  end

  def post_init
  end

  def receive_data(data)
    @env = new_env(*data.split)
    puts "#{env['REQUEST_METHOD']} #{env['PATH_INFO']}"
    EventMachine.defer(method(:pre_process), method(:post_process))
  end

  def pre_process
    @status, @headers, @body = app.call(env)
  end

  def post_process(result)
    response = ''

    response << "HTTP/1.1 #{status} #{status}\r\n"
    headers.each do |k, v|
      response << "#{k}: #{v}\r\n"
    end
    response << "Connection: close\r\n"
    send_data(response)
    send_data("\r\n")
    body.each do |chunk|
      send_data(chunk)
    end
    close_connection_after_writing
  end

  def new_env(method, location, *args)
    {
      'REQUEST_METHOD'   => method,
      'SCRIPT_NAME'      => '',
      'PATH_INFO'        => location,
      'QUERY_STRING'     => location.split('?').last,
      'SERVER_NAME'      => server.host,
      'SERVER_PORT'      => server.port.to_s,
      'rack.version'     => Rack.version.split('.'),
      'rack.url_scheme'  => 'http',
      'rack.input'       => StringIO.new('').set_encoding(Encoding::ASCII_8BIT),
      'rack.errors'      => StringIO.new('').set_encoding(Encoding::ASCII_8BIT),
      'rack.multithread' => true,
      'rack.multiprocess' => true,
      'rack.run_once'    => false
    }
  end
end


