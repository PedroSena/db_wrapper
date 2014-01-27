module DBWrapper
  module SqlParser
    def detect_interested_observers(parsed_string)
      first_statement = parsed_string.split(' ').first
      begin
        klass = Object.const_get 'DBWrapper::Listeners::' + first_statement.capitalize
        klass.types_on_hierarchy
      rescue
        Log.debug 'Could not find a listener for: ' + parsed_string
      end
    end
  end
end