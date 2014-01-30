module DBWrapper
  class DatabaseProxy

    attr_reader :host, :port, :database_host, :database_port
    attr_accessor :protocol

    def initialize(host, port, database_host, database_port, thread_pool_size = 4)
      @host = host
      @port = port
      @database_host = database_host
      @database_port = database_port
      @client_listeners = []
      EM.threadpool_size = thread_pool_size
    end

    def add_client_listener(client_listener)
      @client_listeners << client_listener
    end

    def start!
      raise 'No protocol was given' if self.protocol.nil?
      client_listeners_controller = ListenersController.new @client_listeners
      database_proxy = self
      Proxy.start(host: @host, port: @port) do |conn|
        conn.server :database, host: database_proxy.database_host, port: database_proxy.database_port, relay_server: true

        conn.on_data do |data|
          EM.defer proc { client_listeners_controller.call_listeners(database_proxy.protocol, data) }
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