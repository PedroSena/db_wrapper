require 'benchmark'
require 'mysql2'
require_relative '../lib/db_wrapper'

client = Mysql2::Client.new host: '127.0.0.1', username: 'db_wrapper', password: 'db_wrapper', database: 'db_wrapper_benchmark'

insert = "insert into test values(null, 'some description here', now(), null)"
select = 'select * from test'
delete = 'delete from test'
update = "update test set description = 'another description'"

iterations = 200

Benchmark.bm do |bm|

  bm.report('Proxied access') do
    client = Mysql2::Client.new host: '127.0.0.1', username: 'db_wrapper', password: 'db_wrapper', database: 'db_wrapper_benchmark', port: 3307
    iterations.times do
      client.query select
    end
  end

  bm.report('Direct access') do
    client = Mysql2::Client.new host: '127.0.0.1', username: 'db_wrapper', password: 'db_wrapper', database: 'db_wrapper_benchmark', port: 3306
    iterations.times do
      client.query select
    end
  end

end
