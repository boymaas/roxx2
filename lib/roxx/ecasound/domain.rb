module Roxx
  module Ecasound
    class IdxGenerator
      def initialize
        @current_idx = 0
      end
      def next_idx
        @current_idx += 1
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

    class Channel
      attr_accessor :volume, :audio_file_path, :start_at, :offset, :duration
      def initialize(idx_generator)
        @idx_generator = idx_generator
        @volume = 1
        @start_at = 0.0
        @offset = 0.0
        @duration = nil
      end
      def idx
        @idx ||= @idx_generator.next_idx
      end

      def self.factor(idx_generator, start_at, audio_file_path, offset, duration, volume=1.0)
        new(idx_generator).tap do |c|
         c.start_at = start_at 
         c.volume = volume 
         c.audio_file_path = audio_file_path
         c.offset = offset
         c.duration = duration
        end
      end

      def to_params
          [ "-a:1 -i playat,#{start_at},select,#{offset},#{duration},#{audio_file_path}",
            "-ea:50" ] * ' '
      end

    end

  end
end
