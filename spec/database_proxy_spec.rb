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

  it 'calls the listeners while running' do
    called = false
    EM.run do
      EventMachine.add_timer(0.1) do
        sock = TCPSocket.new '127.0.0.1', 3307
        sock.send "\x10\x00\x00\x00\x03" + 'Select 1 from something', 0
        sock.close
      end
      EventMachine.add_timer(0.2) do
        EM.stop
      end

      proxy.protocol = DBWrapper::MysqlProtocol.new
      proxy.add_listener(DBWrapper::Listeners::Select.new do
        called = true
      end)
      proxy.start!
    end
    expect(called).to be true
  end

  describe 'add_listener' do
    let(:listener) { DBWrapper::Listeners::Select.new do; end }
    before(:each) do
      proxy.add_listener listener
    end
    let(:listeners) { proxy.instance_variable_get(:@listeners) }

    it 'adds a listener' do
      expect(listeners.size).to eq 1
    end
  end

end