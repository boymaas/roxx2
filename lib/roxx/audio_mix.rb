module Roxx
  class AudioMix
    attr_accessor :tracks, :volume

    attr_writer :duration

    def initialize
      @tracks = []
      @volume = 1
      @duration = nil
    end

    def add_track track
      @tracks << track
    end

    def duration
      @duration || @tracks.map(&:duration).max
    end

  end
end
