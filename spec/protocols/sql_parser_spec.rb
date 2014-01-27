require 'spec_helper'
require 'db_wrapper/listeners/sql_command'
require 'db_wrapper/protocols/sql_parser'

describe DBWrapper::SqlParser do
  it 'detects the command based on the beginning of a string' do
    commands = {
        select: 'Select 1 from A',
        update: %q(update A set col1 = 'val1' where col1 = 'val2'),
        insert: %q(insert into A(col1) values('1')),
        delete: %q(DELETE from A where col1 = 'val1')
    }
    class FakeProtocol
      include DBWrapper::SqlParser
    end
    protocol = FakeProtocol.new
    base_listener_types = [:sql_command, :client_listener]
    commands.each_pair do |command, query|
      expect(protocol.detect_interested_observers(query)).to eq ([command.to_sym] + base_listener_types)
    end
  end

end