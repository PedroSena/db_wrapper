require File.expand_path('../lib/db_wrapper/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name = 'db_wrapper'
  spec.version = DBWrapper::VERSION
  spec.date = '2014-01-24'
  spec.description = spec.summary = 'Create custom ruby listeners/interceptors for any database'
  spec.authors = ['Pedro Sena']
  spec.email = 'sena.pedro@gmail.com'
  spec.homepage = 'https://github.com/PedroSena/db_wrapper'
  spec.license = 'MIT'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'em-http-request'
  spec.add_dependency 'em-proxy'
  spec.add_dependency 'log4r'
  spec.add_dependency 'rubysl'

  spec.files = `git ls-files`.split "\n"
  spec.test_files = `git ls-files -- spec/*`.split "\n"
  spec.require_paths = %w(lib)
end