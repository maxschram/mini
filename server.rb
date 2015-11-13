require 'socket'
require 'uri'

webserver = TCPServer.new('localhost', 3000)
puts "Starting server"
while (socket = webserver.accept)
  request = socket.gets
  response = "Hello World"
  socket.print "HTTP/1.1 200 OK\r\n" +
    "Content-Type: text/html\r\n" +
    "Content-Length: #{response.bytesize}\r\n" +
    "Connection: close\r\n"
  socket.print "\r\n"
  socket.print response

  socket.close
end
