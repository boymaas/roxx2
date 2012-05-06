require 'md5'

module Roxx
  class AudioFile
    attr_reader :path

    def initialize(path)
      @path = Pathname.new(path)
      @audio_file_info = AudioFileInfo.new(path)
    end

    def duration
      @audio_file_info.duration
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
