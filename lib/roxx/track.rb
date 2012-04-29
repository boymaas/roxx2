
module Roxx
  class Track
    attr_accessor :sounds, :volume

    def initialize
      @sounds = []
      @volume = 1
    end

    def add_sound(source, pos, duration)
      @sounds << Sound.factor(source,pos,duration)
    end

  end
end
