module Roxx
  class Library
    class SoundNotFound < StandardError; end

    def initialize
      @repository = {}
    end

    def set label, options
      @repository[label] = options
    end

    def fetch(label)
      @repository.fetch(label)
    rescue IndexError => e
      raise SoundNotFound, e
    end
  end
end
