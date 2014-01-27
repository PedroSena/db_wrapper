require 'spec_helper'

describe DBWrapper::DatabaseProxy do

  let(:proxy) { DBWrapper::DatabaseProxy.new '127.0.0.1','3307', '127.0.0.1', '3306' }

  it 'should allow only read of proxy and db connection data' do
    %w(host port database_host database_port).each do |attr|
      expect(proxy.send(attr.to_sym)).to_not be_nil
      expect(proxy.respond_to?("#{attr}=".to_sym)).to be false
    end
  end

  it 'run!' do
    DBWrapper::DatabaseProxy.new '127.0.0.1','3307', '127.0.0.1', '3306' do |proxy|
      proxy.add_listener(DBWrapper::Listeners::Select.new do
        puts 'Select listener got the following command: ' + command
      end)
      proxy.add_listener(DBWrapper::Listeners::Insert.new do
        puts 'Insert listener got the following command: ' + command
      end)
      proxy.protocol = DBWrapper::MysqlProtocol.new
      proxy.run!
    end
  end

  describe 'add_listener' do
    let(:listener) { DBWrapper::Listeners::Select.new do; end }
    before(:each) do
      proxy.add_listener listener
    end
    let(:listeners) { proxy.instance_variable_get(:@listeners) }

    it 'adds a listener inside an array for that given type' do
      expect(listeners.size).to eq 1
      expect(listeners[listener.type].class).to eq Array
    end
    it 'groups listeners of the same type' do
      proxy.add_listener listener
      expect(listeners.size).to eq 1
      expect(listeners[listener.type].size).to eq 2
    end
  end

end