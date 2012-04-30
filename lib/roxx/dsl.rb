module Roxx
  module Dsl
    class Command
      def perform &block
        instance_eval(&block)
      end
    end

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

        unless path
          raise ArgumentError, "need path to audio_file"
        end

        unless options.keys.empty?
          raise ArgumentError, "unknown options specified [#{options.keys * ','}]" 
        end

        # lookup realpath so caching 
        # has correct key
        path       = resolve_path(path)
        audio_file = AudioFile.cache(path)

        @library.set name, audio_file
      end

      def resolve_path path
        path = Pathname.new(path).realpath
      rescue Errno::ENOENT
        raise PathDoesNotExist, path
      end
    end

    class TrackCommand < Command
      def initialize track, library, logger
        @library = library
        @track = track
        @logger = logger
      end

      def sound(name, options = {})
        offset = options.delete(:offset) || 0
        duration = options.delete(:duration) || nil
        unless options.keys.empty?
          raise ArgumentError, "unknown options specified [#{options.keys * ','}]" 
        end
        @track.add_sound(@library.fetch(name), offset, duration)
      rescue Roxx::Library::SoundNotFound
        @logger.log "cannot find sound [#{name}] in library"
        raise
      end
    end

    class AudioMixCommand < Command
      def initialize audio_mix, library, logger
        @library = library
        @audio_mix = audio_mix
        @logger = logger
      end

      def library(&block)
        LibraryCommand.new(@library).perform(&block)
      end

      def track(name, &block)
        track = Track.new
        TrackCommand.new(track, @library, @logger).perform(&block)
        @audio_mix.add_track(track) 
      end
    end
  end

  def self.audio_mix options={}, &block
    logger    = options.delete(:logger)      || Roxx::Logger.new
    library   = options.delete(:library)     || Roxx::Library.new
    audio_mix = options.delete(:audio_mix)   || Roxx::AudioMix.new

    Dsl::AudioMixCommand.new(audio_mix, library, logger).perform(&block)

    [ audio_mix, library, logger ]
  end


end
