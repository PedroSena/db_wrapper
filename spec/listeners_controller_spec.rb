require 'spec_helper'

describe DBWrapper::ListenersController do

  describe 'call_listeners' do
    let(:listener) { DBWrapper::Listeners::Select.new { raise self.command } }

    it 'calls #perform on the listener' do
      module EventMachine
        def self.defer(op = nil, callback = nil, &blk)
          op.call
        end
      end
      EM.run do
        controller = DBWrapper::ListenersController.new [listener]
        command = 'select 1 from a'
        protocol = Object.new
        allow(protocol).to receive(:parse_command).and_return(command)
        allow(protocol).to receive(:detect_interested_observers).and_return([:select])
        expect { controller.call_listeners protocol, command }.to raise_error(command)
        EM.stop
      end
    end

    it 'will ignore if no listener is bound to specific command' do
      controller = DBWrapper::ListenersController.new([])
      command = 'select 1 from a'
      protocol = Object.new
      allow(protocol).to receive(:parse_command).and_return(command)
      allow(protocol).to receive(:detect_interested_observers).and_return([:select])
      controller.call_listeners protocol, command
    end
  end

end
