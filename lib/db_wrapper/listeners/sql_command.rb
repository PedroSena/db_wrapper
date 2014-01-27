require 'listeners/client_listener'

module DBWrapper
  module Listeners
    class SqlCommand < DBWrapper::Listeners::ClientListener; end
    class Select < DBWrapper::Listeners::SqlCommand; end
    class Insert < DBWrapper::Listeners::SqlCommand; end
    class Update < DBWrapper::Listeners::SqlCommand; end
    class Delete < DBWrapper::Listeners::SqlCommand; end
  end
end