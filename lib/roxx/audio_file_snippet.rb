
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

    def has_offset?
      @offset > 0.0
    end

    def is_a_mp3?
      @audio_file.is_a_mp3?
    end

    def duration 
      @duration || (@audio_file.duration - @offset)
    end

    def path
      @audio_file.path
    end

  end
end
