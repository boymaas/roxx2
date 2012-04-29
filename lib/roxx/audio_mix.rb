class AudioMix
  attr_accessor :tracks, :volume

  def initialize
    @tracks = []
    @volume = 1
  end

  def add_track track
    @tracks << track
  end

end
