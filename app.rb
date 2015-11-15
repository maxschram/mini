app = Proc.new do |env|
  ["200", {'Content-Type' => 'text/html'}, ["Hello world"]]
end

Rack::Handler.try_require('./', 'mini')

handler = Rack::Handler.pick(['mini', 'thin', 'webrick'])
handler.run(app)
