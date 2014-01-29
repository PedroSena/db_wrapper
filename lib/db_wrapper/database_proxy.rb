module DBWrapper
  class DatabaseProxy

    attr_reader :host, :port, :database_host, :database_port
    attr_accessor :protocol

    def initialize(host, port, database_host, database_port)
      @host = host
      @port = port
      @database_host = database_host
      @database_port = database_port
      @listeners = []
    end

    def add_listener(listener)
      @listeners << listener
    end

    def start!
      raise 'No protocol was given' if self.protocol.nil?
      listeners_controller = ListenersController.new @listeners
      database_proxy = self
      Proxy.start(host: @host, port: @port) do |conn|
        conn.server :database, host: database_proxy.database_host, port: database_proxy.database_port, relay_server: true

        conn.on_data do |data|
          EM.defer proc { listeners_controller.call_listeners(database_proxy.protocol, data) }
          data
        end

        conn.on_finish do |server, name|
          unbind if server == :database
        end
      end
    end

    def stop!
      Proxy.stop
    end

  end
end