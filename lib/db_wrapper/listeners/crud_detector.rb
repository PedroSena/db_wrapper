module DBWrapper
  module CrudDetector
    def listening?(command)
      self.class.name.split('::').last.downcase == command.split(' ').first.downcase
    end
  end
end
