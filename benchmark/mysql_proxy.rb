require_relative '../lib/db_wrapper'

database_proxy = DBWrapper::DatabaseProxy.new '127.0.0.1', 3307, '127.0.0.1', 3306
database_proxy.protocol = DBWrapper::MysqlProtocol.new
database_proxy.add_client_listener(DBWrapper::Listeners::Select.new do
  puts 'Simple output from select listener'
end)

database_proxy.start!
