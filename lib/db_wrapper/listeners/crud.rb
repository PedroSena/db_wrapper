require 'listeners/client_listener'
require 'listeners/simple_command_detector'

module DBWrapper
  module Listeners
    class Select < DBWrapper::Listeners::ClientListener; include DBWrapper::SimpleCommandDetector; end
    class Insert < DBWrapper::Listeners::ClientListener; include DBWrapper::SimpleCommandDetector; end
    class Update < DBWrapper::Listeners::ClientListener; include DBWrapper::SimpleCommandDetector; end
    class Delete < DBWrapper::Listeners::ClientListener; include DBWrapper::SimpleCommandDetector; end
  end
end