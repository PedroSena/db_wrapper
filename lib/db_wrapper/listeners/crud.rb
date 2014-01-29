require 'listeners/client_listener'
require 'listeners/crud_detector'

module DBWrapper
  module Listeners
    class Select < DBWrapper::Listeners::ClientListener; include DBWrapper::CrudDetector; end
    class Insert < DBWrapper::Listeners::ClientListener; include DBWrapper::CrudDetector; end
    class Update < DBWrapper::Listeners::ClientListener; include DBWrapper::CrudDetector; end
    class Delete < DBWrapper::Listeners::ClientListener; include DBWrapper::CrudDetector; end
  end
end