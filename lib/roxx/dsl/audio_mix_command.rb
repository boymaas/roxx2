module Roxx
  module Dsl
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
end
