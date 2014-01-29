require 'spec_helper'

describe DBWrapper::CrudDetector do

  before(:all) do
    @select_command = 'select 1 from a'
    @insert_command = 'insert into a(col1) values(val1)'
    @update_command = 'update a set col1=val1'
    @delete_command = 'delete from a'
    @all_commands = [@select_command, @insert_command, @update_command, @delete_command]
  end

  %w(select insert update delete).each do |command|
    describe "#{command}" do
      it "listens only to #{command} commands" do
        listener = Object.const_get('DBWrapper::Listeners::' + command.capitalize).new
        correct_command = instance_variable_get(:"@#{command}_command")
        expect(listener.listening?(correct_command)).to be true
        @all_commands.reject { |command| command == correct_command }.each do |unallowed_command|
          expect(listener.listening?(unallowed_command)).to be false
        end
      end
    end
  end

end