
module Roxx
  class AudioFileSnippet
    attr_reader :offset
    def initialize(audio_file, offset, duration)
      @audio_file = audio_file
      @offset = offset
      @duration = duration
    end

    def self.cut(audio_file, offset, duration)
      new(audio_file, offset, duration)
    end

    def duration 
      @duration || (@audio_file.duration - @offset)
    end

    def path
      @audio_file.path
    end

  end
end
