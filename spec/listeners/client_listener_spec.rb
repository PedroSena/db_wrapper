require 'spec_helper'
require 'db_wrapper/listeners/client_listener'

describe DBWrapper::Listeners::ClientListener do
  let(:client_listener) { DBWrapper::Listeners::ClientListener }

  it 'returns :client_listener as type' do
    expect(client_listener.type).to eq :client_listener
  end

  it 'returns an array containing all types in the hierarchy' do
    class FakeChildren < DBWrapper::Listeners::ClientListener; end
    expect(FakeChildren.types_on_hierarchy).to eq [:fake_children, :client_listener]
  end
end