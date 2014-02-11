require_relative '../lib/db_wrapper'

database_proxy = DBWrapper::DatabaseProxy.new '127.0.0.1', 3307, '127.0.0.1', 3306
database_proxy.protocol = DBWrapper::MysqlProtocol.new

listeners = 100.times.map do |index|
	DBWrapper::Listeners::Select.new do
		puts "I'm listener #{index} and the command is: " + command + "\n"
	end
end

listeners.each { |listener| database_proxy.add_client_listener(listener) } 

database_proxy.start!
