
module Roxx
  class Sound
    attr_reader :source, :position

    def initialize(source, position, duration)
      @source = source
      @position = position
      @duration = duration
    end

    def self.factor(source, pos, duration=nil)
      new(source, pos, duration)
    end

    def start_time
      position
    end

    def end_time
      position + duration
    end

    def duration
      @duration || @source.duration
    end

  end
end
