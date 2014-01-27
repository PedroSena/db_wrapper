$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'em-proxy'
require 'sidekiq'

%w(listeners protocols).each do |dir|
  Dir["#{dir}/*.rb"].each { |file| require file }
end
