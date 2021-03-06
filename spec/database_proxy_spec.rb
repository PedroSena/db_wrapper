require 'spec_helper'
require 'em-http-request'

describe DBWrapper::DatabaseProxy do

  let(:proxy) { DBWrapper::DatabaseProxy.new '127.0.0.1','3307', '127.0.0.1', '3306' }

  it 'should allow only read of proxy and db connection data' do
    %w(host port database_host database_port).each do |attr|
      expect(proxy.send(attr.to_sym)).to_not be_nil
      expect(proxy.respond_to?("#{attr}=".to_sym)).to be false
    end
  end

  it 'calls the client listeners while running' do
    called = false
    EM.run do
      EventMachine.add_timer(0.1) do
        sock = TCPSocket.new '127.0.0.1', 3307
        sock.send "\x10\x00\x00\x00\x03" + 'Select 1 from something;', 0
        sock.close
      end
      EventMachine.add_timer(0.2) do
        EM.stop
      end

      proxy.protocol = DBWrapper::MysqlProtocol.new
      listener = DBWrapper::Listeners::Select.new do
        called = true
      end
      proxy.add_client_listener(listener)
      Socket.should_receive(:accept_loop) do |&block|
        listener.perform
      end
      proxy.should_receive(:fork) do |&block|
        block.call
      end
      proxy.start!
    end
    expect(called).to be true
  end

  describe 'add_client_listener' do
    let(:listener) { DBWrapper::Listeners::Select.new do; end }
    before(:each) do
      proxy.add_client_listener listener
    end
    let(:client_listeners) { proxy.instance_variable_get(:@client_listeners) }

    it 'adds a listener' do
      expect(client_listeners.size).to eq 1
    end
  end

end