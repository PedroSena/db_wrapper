require 'spec_helper'

describe DBWrapper::SimpleCommandDetector do

  let(:commands) { ['select 1 from a', 'insert into a(col1) values(val1)', 'update a set col1=val1', 'delete from a'] }

  %w(select insert update delete).each do |command|
    describe "#{command}" do
      it "listens only to #{command} commands" do
        correct_command = commands.select { |sql_command| sql_command.start_with?(command)  }.first
        listener = get_listener(correct_command)
        expect(listener.listening?(correct_command)).to be true
        commands.reject { |sql_command| sql_command == correct_command }.each do |unallowed_command|
          expect(listener.listening?(unallowed_command)).to be false
        end
      end
    end
  end

  #Object.const_get didnt work in rubinius =/
  def get_listener(command)
    case command.split(' ').first
      when 'select' then DBWrapper::Listeners::Select.new
      when 'insert' then DBWrapper::Listeners::Insert.new
      when 'update' then DBWrapper::Listeners::Update.new
      when 'delete' then DBWrapper::Listeners::Delete.new
    end
  end

end