module DBWrapper
  class MysqlProtocol
    def parse_command(dirty_command)
      dirty_command.byteslice(5, dirty_command.length)
    end
    def max_packet_size
    	2 ** 24 - 1
    end
  end
end