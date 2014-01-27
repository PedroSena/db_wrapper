require 'protocols/sql_parser'

module DBWrapper
  class MysqlProtocol
    include DBWrapper::SqlParser

    def parse_command(dirty_command)
      dirty_command.byteslice(5, dirty_command.length)
    end
  end
end