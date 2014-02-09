$:.unshift(File.dirname(__FILE__) + '/db_wrapper')

require 'em-proxy'
require 'log4r'
require 'socket'

Log = Log4r::Logger.new 'db_wrapper'
Log.add Log4r::Outputter.stderr
Log.level = Log4r::DEBUG

Gem.find_files("#{File.dirname(__FILE__)}/**/*.rb").each { |file| require file }