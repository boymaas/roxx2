module Roxx
  class AudioFile
    attr_reader :path

    def initialize(path)
      @path = Pathname.new(path)
      @audio_file_info = AudioFileInfo.new(path)
    end

    def duration_in_seconds
      @audio_file_info.duration_in_seconds
    end
  end
end
