
module Roxx
  class Sound
    attr_reader :source, :position, :duration

    def initialize(source, position, duration)
      @source = source
      @position = position
      @duration = duration
    end

    def self.factor(source, pos, duration)
      new(source, pos, duration)
    end
  end
end
