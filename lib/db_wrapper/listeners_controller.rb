module DBWrapper
  class ListenersController

    def initialize(listeners)
      @listeners = listeners
    end

    def call_listeners(protocol, raw_command)
      return if @listeners.nil?
      parsed_command = protocol.parse_command raw_command
      return if parsed_command.empty?
      @listeners.select { |listener| listener.listening?(parsed_command) }.each do |listener|
        listener.command = parsed_command
        EM.defer { listener.perform }
      end
    end

  end
end