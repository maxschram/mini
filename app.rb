class App
  def self.call(env)
    ["200", {'Content-Type' => 'text/html'}, ["Hello world"]]
  end
end

Rack::Handler.try_require('./', 'mini')
