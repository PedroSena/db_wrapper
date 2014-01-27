module DBWrapper
  class ListenersController

    def initialize(listeners)
      @listeners = listeners
    end

    def call_listeners(protocol, raw_command)
      parsed_command = protocol.parse_command raw_command
      interested_observers_types = protocol.detect_interested_observers parsed_command
      interested_observers_types.each { |type| run_listeners type, parsed_command } unless interested_observers_types.nil?
    end

    private
    def run_listeners(type, parsed_command)
      listeners = @listeners[type]
      return if listeners.nil? || listeners.empty?
      listeners.each { |listener| listener.perform(parsed_command) }
    end
  end
end