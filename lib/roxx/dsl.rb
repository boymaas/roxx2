module Roxx
  module Dsl
    class LibraryCommand
      attr_reader :repository

      def initialize library, &block
        @repository = library 
        instance_eval(&block)
      end

      def set name, options = {}
        @repository.set name, options
      end

    end

    class TrackCommand
      def initialize track, library, logger, &block
        @repository = library
        @track = track
        @logger = logger
        instance_eval(&block)
      end

      def sound name, options = {}
        @track.add_sound(@repository.fetch(name))
      rescue Library::SoundNotFound
        @logger.log "cannot find sound [#{name}] in library"
      end
    end
  end
end
