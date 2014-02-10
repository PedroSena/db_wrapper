module DBWrapper
  class DatabaseProxy

    attr_reader :host, :port, :database_host, :database_port, :listener_server_socket
    attr_accessor :protocol

    def initialize(host, port, database_host, database_port)
      @host = host
      @port = port
      @database_host = database_host
      @database_port = database_port
      @client_listeners = []
    end

    def add_client_listener(client_listener)
      @client_listeners << client_listener
    end

    def start!
      raise 'No protocol was given' if self.protocol.nil?
      listener_server_port = create_listener_server.addr[1]
      @listener_server_socket = TCPSocket.new(self.host, listener_server_port)
      database_proxy = self
      Proxy.start(host: @host, port: @port) do |conn|
        conn.server :database, host: database_proxy.database_host, port: database_proxy.database_port, relay_server: true

        conn.on_data do |data|
          database_proxy.listener_server_socket.write_nonblock(data)
          data
        end

        conn.on_finish do |server, name|
          unbind if server == :database
        end
      end
    end

    def create_listener_server
      listener_server = TCPServer.new(host, 0) #Creates on first free port it can find
      client_listeners_controller = ListenersController.new @client_listeners
      fork do
        Socket.accept_loop(listener_server) do |connection|
          begin
            while data = connection.readpartial(self.protocol.max_packet_size) do
              client_listeners_controller.call_listeners(self.protocol, data)
            end
          rescue Interrupt; end  #Thrown when you send a termination signal
        end          
      end
      listener_server      
    end  

  end
end