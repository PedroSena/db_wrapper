require 'spec_helper'

describe DBWrapper::Listeners::ClientListener do
  let(:client_listener) { DBWrapper::Listeners::ClientListener.new do; end }
  it 'is listening to every query' do
    ['select 1 from a', 'insert into a(col1) values(1)', 'update a set col1=val1 where col1=something', 'delete from a where col1=something'].each do |query|
      expect(client_listener.listening?(query)).to be true
    end
  end

  it 'executes the code block on perform' do
    executed = false
    listener = DBWrapper::Listeners::ClientListener.new do
      executed = true
    end
    listener.perform
    expect(executed).to be true
  end

end