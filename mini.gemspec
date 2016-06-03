Gem::Specification.new do |s|
  s.name = 'mini'
  s.version = '0.0.1'
  s.executables << 'mini'
  s.date = '2016-6-02'
  s.summary = 'Super lightweight Rack compliant Web server'
  s.description = 'A very small Ruby web server'
  s.authors = ['Max Schram']
  s.email = ''
  s.files = ['lib/mini.rb', 'lib/mini/connection.rb']
  s.license = 'MIT'

  s.files = %w(README.md) +
            DIR["{bin, example, lib}/**/*"]

  s.add_dependency 'rack'
  s.add_dependency 'eventmachine'
end
