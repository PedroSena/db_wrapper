#Base listener for all data sent from the client to the database
module DBWrapper
  module Listeners
    class ClientListener

      attr_accessor :command

      def initialize(&block)
        @block = block
      end

      def perform
        instance_eval(&@block)
      end

      def listening?(query)
        true
      end

    end
  end
end
