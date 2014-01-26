module DBWrapper
  module MysqlProtocol
    def self.parse_command(dirty_command)
      dirty_command.byteslice(5, dirty_command.length)
    end
  end
end