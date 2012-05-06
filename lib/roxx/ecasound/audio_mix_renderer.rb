module Roxx
  module Ecasound
    class AudioMixRenderer
      def initialize(audio_mix)
        @audio_mix = audio_mix 
      end

      def render
        @tracks = @audio_mix.tracks.map do |track|
          TrackRenderer.new(track) 
        end
      end
    end

    class Loopback
      attr_accessor :volume
      attr_accessor :channels
      def initialize(idx_generator)
        @idx_generator = idx_generator
        @volume = 1
        @channels = []
      end

      def idx
        @idx ||= @idx_generator.next_idx
      end

      def to_params
        return [] if @channels.empty?
        @channels.map(&:to_params) + ["-a:#{@channels.map(&:idx) * ','} -o loop,#{idx} -ea:#{volume * 100}"]
      end
    end

    class IdxGenerator
      def initialize
        @current_idx = 0
      end
      def next_idx
        @current_idx += 1
      end
    end
  end
end
