module Roxx
  module Dsl
    class LibraryCommand < Command
      class PathDoesNotExist < StandardError; end

      attr_reader :library

      def initialize library
        @library = library 
      end

      def audio_file name, options = {}
        offset = options.delete(:offset) || nil
        duration = options.delete(:duration) || nil
        path = options.delete(:path) || nil

        raise_argument_condition_when path.nil?,
          :and_display => "need path to audio file"

        raise_argument_condition_when !options.keys.empty?,
          :and_display => "unknown options specified [#{options.keys * ','}]" 

        # lookup realpath so caching 
        # has correct key
        path       = resolve_path(path)
        audio_file = AudioFile.cache(path)

        # duration is specified, transfor into a snippet
        unless offset.nil?
          audio_file = AudioFileSnippet.cut(audio_file, offset, duration)
        end

        @library.set name, audio_file
      end


      def resolve_path path
        path = Pathname.new(path).realpath
      rescue Errno::ENOENT
        raise PathDoesNotExist, path
      end
    end
  end
end
