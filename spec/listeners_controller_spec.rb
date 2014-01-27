require 'spec_helper'
require 'db_wrapper/listeners_controller'
require 'db_wrapper/listeners/sql_command'

describe DBWrapper::ListenersController do
  let(:controller) { DBWrapper::ListenersController.new }
  let(:listener) { DBWrapper::Listeners::Select.new do; end }

  describe 'add_listener' do
    before(:each) do
      controller.add_listener listener
    end
    let(:listeners) { controller.instance_variable_get(:@listeners) }
    it 'adds a listener inside an array for that given type' do
      expect(listeners.size).to eq 1
      expect(listeners[listener.type].class).to eq Array
    end
    it 'groups listeners of the same type' do
      controller.add_listener listener
      expect(listeners.size).to eq 1
      expect(listeners[listener.type].size).to eq 2
    end
  end

  describe 'call_listeners' do
    it 'calls #perform on the listener' do
      command = 'select 1 from a'
      protocol = Object.new
      allow(protocol).to receive(:parse_command).and_return(command)
      allow(protocol).to receive(:detect_interested_observers).and_return([:select])
      listener = DBWrapper::Listeners::Select.new { raise command }
      controller.add_listener listener
      expect { controller.call_listeners protocol, command }.to raise_error(command)
    end
  end

end
