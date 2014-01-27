require 'db_wrapper/util/underscore'

#Base listener for all data sent from the client to the database
module DBWrapper
  module Listeners
    class ClientListener
      attr_accessor :command

      def initialize(&block)
        @block = block
      end

      def perform(parsed_command)
        self.command = parsed_command
        instance_eval(&@block)
      end

      def self.type
        self.name.split('::').last.underscore.to_sym
      end

      def type
        self.class.type
      end

      def self.types_on_hierarchy
        [].tap do |types|
          klass = self
          begin
            types << klass.type
            klass = klass.superclass
          end while klass != Object
        end
      end
    end
  end
end
