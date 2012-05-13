require 'md5'

module Roxx
  class AudioFile
    attr_reader :path, :offset

    def initialize(path)
      @path = Pathname.new(path)
      @audio_file_info = AudioFileInfo.new(path)
      @offset = 0.0
    end

    def duration
      @audio_file_info.duration
    end

    def has_offset?
      false
    end

    def is_a_mp3?
      @path.extname.downcase == '.mp3'
    end

    class << self
      def cache path
        @cache ||= {}
        @cache[hash_of_path(path)] ||= self.new(path)
      end

      def hash_of_path path
        MD5.hexdigest(path)
      end
    end
  end
end
