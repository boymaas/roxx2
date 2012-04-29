
module Roxx
  class AudioFileSnippet
    attr_reader :offset, :duration_in_seconds
    def initialize(audio_file, offset, duration_in_seconds)
      @audio_file = audio_file
      @offset = offset
      @duration_in_seconds = duration_in_seconds
    end

    def self.cut(audio_file, offset, duration)
      new(audio_file, offset, duration)
    end

  end
end
