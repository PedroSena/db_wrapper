module DBWrapper
  module SqlParser
    def detect_interested_observers(parsed_string)
      first_statement = parsed_string.split(' ').first
      klass = Object.const_get "DBWrapper::Listeners::" + first_statement.capitalize
      klass.types_on_hierarchy
    end
  end
end