module Roxx
  module Dsl
    class TrackCommand < Command
      def initialize track, library, logger
        @library = library
        @track = track
        @logger = logger
      end

      def sound(name, options = {})
        offset = options.delete(:offset) || 0
        duration = options.delete(:duration) || nil

        raise_argument_condition_when !options.keys.empty?,
          :and_display => "unknown options specified [#{options.keys * ','}]"   

        @track.add_sound(@library.fetch(name), offset, duration)

      rescue Roxx::Library::SoundNotFound
        @logger.log "cannot find sound [#{name}] in library"
        raise
      end
    end
  end
end
