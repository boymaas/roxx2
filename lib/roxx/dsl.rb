module Roxx
  module Dsl
    module Classes
      class LibraryCommand
        attr_reader :library

        def initialize library, &block
          @library = library 
          instance_eval(&block)
        end

        def set name, options = {}
          @library.set name, options
        end

      end

      class TrackCommand
        def initialize track, library, logger, &block
          @library = library
          @track = track
          @logger = logger
          instance_eval(&block)
        end

        def sound name, options = {}
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

      class AudioMixCommand
        def initialize audio_mix, library, logger, &block
          @library = library
          @audio_mix = audio_mix
          @logger = logger
          instance_eval(&block)
        end

        def library(&block)
          LibraryCommand.new @library, &block
        end

        def track name, &block
          track = Track.new
          TrackCommand.new track, @library, @logger, &block
          @audio_mix.add_track(track) 
        end
      end
    end



  end

  def self.audio_mix logger=nil, &block
    logger ||= Roxx::Logger.new
    library = Roxx::Library.new
    audio_mix = Roxx::AudioMix.new

    Dsl::Classes::AudioMixCommand.new audio_mix, library, logger, &block

    audio_mix
  end


end
