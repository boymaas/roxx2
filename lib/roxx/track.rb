
module Roxx
  class Track
    attr_accessor :sounds, :volume

    attr_writer :duration

    def initialize
      @sounds = []
      @volume = 1
      @duration = nil
      
    end

    def add_sound(source, pos, duration=nil)
      @sounds << Sound.factor(source,pos,duration)
    end

    def duration
      @duration || sounds.map(&:end_time).max
    end

  end
end
